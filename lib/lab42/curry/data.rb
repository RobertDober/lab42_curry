require_relative 'arg_compiler'

module Lab42
  module Curry
    class Data
      attr_accessor :allow_kwd_override
      attr_reader :context, :ct_args, :ct_kwds, :curried

      private
      def initialize(ctxt, method_or_name, *curry_time_args, **curry_time_kwds, &blk)
        @allow_kwd_override
        @context = ctxt
        @ct_args = curry_time_args
        @ct_kwds = curry_time_kwds

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
        @curried = ->(*rt_args, **rt_kwds) do
          @mthd.(
            *@arg_compiler.compile_args(rt_args),
            **@ct_kwds.merge(rt_kwds) { |kwd, old_val, new_val|
              if allow_kwd_override
                new_val
              else
                raise DuplicateKeywordArgument, "keyword argument #{kwd.inspect} is already defined with value #{old_val.inspect} cannot override with #{new_val.inspect}"
              end
            }
          )
        end
      end
    end
  end
end
