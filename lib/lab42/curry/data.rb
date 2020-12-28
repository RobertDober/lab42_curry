require_relative 'arg_compiler'

module Lab42
  module Curry
    class Data
      attr_reader :allow_overrides, :context, :ct_args, :ct_blk, :ct_kwds, :curried

      class << self
        def new!(*args, **kwds, &blk)
          new(*args, **kwds, &blk)
            .tap{ |slf| slf.instance_variable_set("@allow_overrides", true) }
        end
      end

      private
      def initialize(ctxt, method_or_name, *curry_time_args, **curry_time_kwds, &blk)
        @allow_overrides = false
        @context = ctxt
        @ct_args = curry_time_args
        @ct_blk  = blk
        @ct_kwds = curry_time_kwds
        _init_mthd method_or_name

        @arg_compiler = ArgCompiler.new(ct_args)
        _curry
      end

      def _curry
        case @mthd
        when UnboundMethod
          _curry_with_bind
        else
          _curry_with_call
        end
      end

      def _curry_with_bind
        @curried = ->(receiver, *rt_args, **rt_kwds, &blk) do
          blk = _set_blk!(blk)
          if blk
            _curried_with_blk @mthd.bind(receiver), rt_args, rt_kwds, blk
          else
            _curried_no_blk @mthd.bind(receiver), rt_args, rt_kwds
          end
        end
      end

      def _curry_with_call
        @curried = ->(*rt_args, **rt_kwds, &blk) do
          blk = _set_blk!(blk)
          if blk
            _curried_with_blk @mthd, rt_args, rt_kwds, blk
          else
            _curried_no_blk @mthd, rt_args, rt_kwds
          end
        end
      end

      def _curried_no_blk mthd, rt_args, rt_kwds
        mthd.(
          *@arg_compiler.compile_args(rt_args),
          **@ct_kwds.merge(rt_kwds) { |kwd, old_val, new_val|
            if allow_overrides
              new_val
            else
              raise DuplicateKeywordArgument, "keyword argument #{kwd.inspect} is already defined with value #{old_val.inspect} cannot override with #{new_val.inspect}"
            end
          })
      end

      def _curried_with_blk mthd, rt_args, rt_kwds, blk
        mthd.(
          *@arg_compiler.compile_args(rt_args),
          **@ct_kwds.merge(rt_kwds) { |kwd, old_val, new_val|
            if allow_overrides
              new_val
            else
              raise DuplicateKeywordArgument, "keyword argument #{kwd.inspect} is already defined with value #{old_val.inspect} cannot override with #{new_val.inspect}"
            end
          }, &blk)
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

      def _set_blk! blk
        raise DuplicateBlock, "block has already been curried" if ct_blk && blk && !allow_overrides
        blk || ct_blk
      end
    end
  end
end
