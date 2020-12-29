require_relative "curry/compiletime_args"
require_relative "curry/computed_arg"
require_relative "curry/currier"
require_relative "curry/runtime_arg"

module Lab42
  module Curry
    def curry(method_or_name, *curry_time_args, **curry_time_kwds, &blk)
      Currier.new(method_or_name, curry_time_args, curry_time_kwds, context: self, &blk)
    end

    def curry!(method_or_name, *curry_time_args, **curry_time_kwds, &blk)
      Currier.new(method_or_name, curry_time_args, curry_time_kwds, context: self, allow_override: true, &blk)
    end

    def compiletime_args(positions)
      CompiletimeArgs.new(positions)
    end
    alias_method :ct_args, :compiletime_args

    def compute_arg(&blk)
      ComputedArg.new(blk)
    end
    alias_method :comp, :compute_arg

    def runtime_arg # position=nil
      RuntimeArg.new # position&.pred
    end
    alias_method :rt_arg, :runtime_arg
  end
end

