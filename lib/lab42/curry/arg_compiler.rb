require_relative 'runtime_arg'
require_relative 'compiletime_args'
require_relative 'errors'

module Lab42
  module Curry
    class ArgCompiler

      def compile_args rt_args
        @__compiled_args__ ||= _compile_args(rt_args)
      end

      private
      def initialize(ct_args)
        _init
        _determine_predefined_positions! ct_args
      end

      def _compile_args rt_args
        @rt_args = rt_args
        @rt_arg_positions.each(&method(:_set_rt_arg))
        @rt_args.each(&method(:_set_final!))
        @final.map.sort_by(&:first).map(&:last)
      end

      def _determine_predefined_positions! ct_args
        ct_args.each(&method(:_set_ct_arg))
      end

      def _init
        @rt_arg_positions = []
        # invariant @pos is lowest free index in @final
        # update both together with _set_final!( value, idx = @pos )
        @pos = 0
        @final = {}
      end

      def _set_ct_arg ct_arg
        case ct_arg
        when RuntimeArg
          _set_target_position! ct_arg.position
        when CompiletimeArgs
          _set_positions! ct_arg
        else
          _set_final! ct_arg
        end
      end

      def _set_final! value, pos=nil
        pos ||= @pos
        raise DuplicatePositionSpecification, "There is already a curried value for #{pos}" if @final.has_key?(pos)
        @final[pos] = value
        while @final.has_key?(@pos)
          @pos += 1
        end
      end

      def _set_position!((position, value))
        _set_final! value, position
      end

      def _set_positions! ct_arg
        ct_arg.each(&method(:_set_position!))
      end

      def _set_rt_arg rt_arg_position
        raise MissingRuntimeArg, "for position #{rt_arg_position}" if @rt_args.empty?
        @final[rt_arg_position] = @rt_args.shift
      end

      def _set_target_position! position
        @rt_arg_positions << (position || @pos)
        _set_final! RuntimeArg, position
      end

    end
  end
end
