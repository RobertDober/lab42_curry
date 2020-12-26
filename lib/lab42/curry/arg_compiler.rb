require_relative 'runtime_arg'
require_relative 'compiletime_args'
require_relative 'errors'

module Lab42
  module Curry
    class ArgCompiler
      attr_reader :ct_args, :rt_args
      
      def compile_args
        _init
        ct_args.each(&method(:_set_ct_arg))
        rt_args.each(&method(:_set_rt_arg))
        @final.map.sort_by(&:first).map(&:last)
      end
      
      private
      def initialize(ct_args:, rt_args:)
        @ct_args = ct_args
        @rt_args = rt_args
      end

      def _init
        @pos = 0
        @final = {}
      end

      def _set_compiletime_arg ct_arg
        _store_into_next(ct_arg)
      end

      def _set_ct_arg ct_arg
        case ct_arg
        when RuntimeArg
          _set_runtime_arg! ct_arg # changes @rt_args, I know, I know, TODO: make this w/o side effect
        when CompiletimeArgs
          _set_positions ct_arg
        else
          _set_compiletime_arg ct_arg
        end
      end

      def _set_position((pos, val))
        _store_at! val, pos
      end

      def _set_positions ct_arg
        ct_arg.each(&method(:_set_position))
      end

      def _set_rt_arg rt_arg
        _store_into_next(rt_arg)
      end

      def _set_runtime_arg! ct_arg 
        if ct_arg.position 
          _store_at! rt_args.shift, ct_arg.position # This is the culprit
        else
          _store_into_next(rt_args.shift) # Oops I did it again
        end
      end

      def _store_at!(value, pos=nil)
        pos ||= @pos
        raise DuplicatePositionSpecification, "There is already a curried value #{@final[pos].inspect} at position #{pos}, attempting to override with #{value.inspect}" if
          @final.has_key?(pos)
        @final[pos] = value
      end

      def _store_into_next(value)
        while @final.has_key?(@pos)
          @pos += 1
        end
        _store_at! value
      end
    end
  end
end
