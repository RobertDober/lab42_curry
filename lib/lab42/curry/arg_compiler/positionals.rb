require_relative '../errors'
require_relative '../runtime_arg'
# Represents the positionitional arguments as
# a hash idx -> value with operations to
# fill the "holes" with args provisioned
# at runtime.
# The filling of the holes is done at runtime
# by translating runtime argument indices with
# the @translations hash.
module Lab42
  module Curry
    class ArgCompiler
      class Positionals

        attr_reader :ct_pos, :rt_pos

        def computations
          @computations.each { |idx, comp| yield idx, comp }
        end

        def computed idx
          @computations[idx]
        end

        def export_args
          @args.values_at(*0..@args.keys.max)
        end

        def set_computation comp_arg
          @args[ct_pos]         = comp_org.class
          @computations[rt_pos] = comp_arg
          @translations[rt_pos] = ct_pos # comp_arg.position || rt_pos if comp(position){...} is implemented
        end

        # An rt_arg placeholder
        def set_runtime_arg rt_arg 
          @args[ct_pos.pred] = rt_arg.class
          @translations[rt_arg.position || rt_pos] = ct_pos
          _update_positions
        end

        # A curried value or computation, occurs from `ct_args` or literal values in which case `ct_pos` is `nil` 
        def set_value! value, ct_pos=nil
          ct_pos ||= @ct_pos
          raise Lab42::Curry::DuplicatePositionSpecification,
            "There is already a curried value #{@args[ct_pos].inspect} at index #{ct_pos}" if _occupied?(ct_pos)
          @args[ct_pos] = value

          (@ct_pos..ct_pos.pred).each(&method(:_occupy))
          # TODO: Need to check if we have to fill the holes with RuntimeArg
          # and allow @ct_pos to point to present RuntimeArg values?

          _update_positions
        end

        def translation idx
          @translations[idx]
        end

        private
        def initialize
          @args         = {}
          @computations = {}
          @ct_pos       = 0
          @rt_pos       = 0
          @translations = {}
        end

        def _occupied? key
          @args.has_key?(key) && @args[key] != RuntimeArg
        end

        def _occupy idx
          @args[idx] = RuntimeArg unless @args.has_key?(idx)
        end

        def _update_positions
          while @args.has_key?(@ct_pos)
            @ct_pos += 1
          end
          while @translations.has_key?(@rt_pos)
            @rt_pos += 1
          end
        end
      end
    end
  end
end

