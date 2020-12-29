require_relative 'arg_compiler/positionals'
require_relative 'arg_compiler/phase2'
require_relative 'compiletime_args'
require_relative 'computed_arg'
require_relative 'runtime_arg'

require_relative 'errors'

module Lab42
  module Curry
    class ArgCompiler

      attr_reader :ct_blk

      def allows_override?; @allows_override end

      def compile(rt_args, rt_kwds, rt_blk)
        Phase2.new(self, rt_args, rt_kwds, rt_blk).compile
      end

      #
      #  All four state variables are 0 based
      #
      def computations
        @__computations__ ||= {}
      end

      def positionals
        @__positionals__ ||= Positionals.new 
      end

      def final_kwds
        @__final_kwds__ ||= {}
      end

      private
      def initialize(ct_args, ct_kwds, allow_override:, &blk)
        @allow_override = allow_override
        @ct_args = ct_args
        @ct_blk  = ct_blk
        @ct_kwds = ct_kwds

        _precompile!
      end

      def _ct_arg ct_arg
        case ct_arg
        when RuntimeArg
          positionals.set_runtime_arg ct_arg
        when CompiletimeArgs
          _set_positions! ct_arg
        when ComputedArg
          positionals.set_computation ct_arg
        else
          _set_final! ct_arg
        end
      end

      def _ct_kwd((key, val))
        case val
        when ComputedArg
          cmputations[key] = val.with_position(key)
          final_kwds[key]  = RuntimeArg
        else
          final_kwds[key]  = val
        end
      end

      def _precompile!
        @ct_args.each(&method(:_ct_arg))
        @ct_kwds.each(&method(:_ct_kwd))
      end

      def _set_final! value, pos=nil
        positionals.set_value! value, pos
      end

      def _set_position!((position, value))
        positionals.set_value! value, position.pred
      end

      def _set_positions! ct_arg
        ct_arg.each(&method(:_set_position!))
      end

    end
  end
end
