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

        @arg_compiler = ArgCompiler.new(ct_args)
        _curry(&blk)
      end

      def _curry(&blk)
        @curried = ->(*rt_args) { @mthd.(*@arg_compiler.compile_args(rt_args)) }
      end
    end
  end
end
