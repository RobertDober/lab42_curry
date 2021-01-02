require_relative '../errors'
require_relative 'positionals'
module Lab42
  module Curry
    class ArgCompiler
      class Phase2

        attr_reader :compiler, :rt_args, :rt_blk, :rt_kwds

        # TODO: Easy, peasy sequential refactor
        def compile
          if rt_blk && compiler.ct_blk && !compiler.allows_override?
            raise Lab42::Curry::DuplicateBlock, "block has already been curried"
          end
          @blk = rt_blk || compiler.ct_blk
          @kwds = compiler.final_kwds.merge(rt_kwds){ |k, old, new|
            raise Lab42::Curry::DuplicateKeywordArgument,
              "keyword argument :#{k} is already defined with value #{old.inspect} cannot override with #{new.inspect}" unless compiler.allows_override?
            new
          }
          @args = compiler.positionals.export_args
          @first_free = 0
          rt_args.each_with_index do |rt_arg, idx|
            computed   = compiler.positionals.computed(idx)
            if computed
            end
            translated = compiler.positionals.translation(idx)
            if translated
              @args[translated] = rt_arg
            else
              # @args[idx + some_dynamic_offset] = rt_arg ???
              _occupy_first_free rt_arg
            end
          end
          compiler.positionals.computations do |idx, computed_arg|
            @args[idx] = _compute(computed_arg)
          end
          @kwds.each do |kwd, val|
            case val
            when ComputedArg
              @kwds[kwd] = _compute(val)
            end
          end
          # TODO: Raise ArgumentError if holes are left in @args, but for that reason we must make compiler.final_args compact
          # and indicate wholes with RuntimeArg, not sure this is done same for holes in @kwds
          [@args, @kwds, @blk]
        end

        private

        def initialize(compiler, rt_args, rt_kwds, rt_blk)
          @compiler = compiler
          @rt_args  = rt_args
          @rt_blk   = rt_blk
          @rt_kwds  = rt_kwds
        end

        def _compute computed_arg
          computed_arg.(*@args, **@kwds)
        end

        def _occupy_first_free with_value
          return @args << with_value unless @first_free
          @first_free = 
            (@first_free..@args.size).find {|idx| @args[idx] == RuntimeArg}
          if @first_free
            @args[@first_free] = with_value
          else
            @args << with_value
          end
        end
      end
    end
  end
end
