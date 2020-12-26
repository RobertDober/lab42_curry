require_relative 'arg_compiler'

module Lab42
  module Curry
    class Data
      attr_reader :context, :ct_args, :curried

      private
      def initialize(ctxt, method_or_name, *curry_time_args, &blk)
        @context = ctxt
        @ct_args = curry_time_args

        @mthd = 
        case method_or_name
        when Symbol
          context.method(method_or_name)
        else
          method_or_name
        end
        _curry(&blk)
      end

      def _compile_final_args(rt_args)
        arg_compiler = ArgCompiler.new(ct_args: ct_args, rt_args: rt_args)
        arg_compiler.compile_args
      end

      def _curry(&blk)
        @curried = ->(*rt_args) { @mthd.(*_compile_final_args(rt_args)) }
      end
    end
  end
end
