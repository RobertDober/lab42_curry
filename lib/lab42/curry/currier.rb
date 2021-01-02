require_relative 'arg_compiler'

module Lab42
  module Curry
    class Currier
      attr_reader :arg_compiler, :context, :ct_args, :ct_blk, :ct_kwds, :mthd

      def call(*args, **kwds, &blk)
        case mthd
        when UnboundMethod
          _bind_and_call(args, kwds, blk)
        else
          _just_call(args, kwds, blk)
        end
      end

      def _bind_and_call(args, kwds, blk)
        receiver = args.shift
        mthd = @mthd.bind(receiver)
        rt_args, rt_kwds, rt_blk = arg_compiler.compile(args, kwds, blk)
        if rt_blk
          mthd.(*rt_args, **rt_kwds, &rt_blk)
        else
          mthd.(*rt_args, **rt_kwds)
        end
      end

      def _just_call(args, kwds, blk)
        rt_args, rt_kwds, rt_blk = arg_compiler.compile(args, kwds, blk)
        if rt_blk
          mthd.(*rt_args, **rt_kwds, &rt_blk)
        else
          mthd.(*rt_args, **rt_kwds)
        end
      end

      private
      def initialize(method_or_name, ct_args, ct_kwds, context:, allow_override: false, &ct_blk)
        @allow_override = allow_override
        @context = context
        @ct_args = ct_args
        @ct_blk = ct_blk
        @ct_kwds = ct_kwds

        @arg_compiler = ArgCompiler.new(ct_args, ct_kwds, allow_override: allow_override, &ct_blk)

        _init_mthd method_or_name
      end

      def _init_mthd method_or_name
        @mthd = 
          case method_or_name
          when Symbol
            context.method(method_or_name)
          else
            method_or_name
          end
      end
    end
  end
end
