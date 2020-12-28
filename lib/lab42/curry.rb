require_relative "curry/data"
require_relative "curry/runtime_arg"
require_relative "curry/compiletime_args"

module Lab42
  module Curry
    def curry(method_or_name, *curry_time_args, **curry_time_kwds, &blk)
      curry_data = Data.new(self, method_or_name, *curry_time_args, **curry_time_kwds, &blk)
      curry_data.curried
    end

    def curry!(method_or_name, *curry_time_args, **curry_time_kwds, &blk)
      curry_data = Data.new!(self, method_or_name, *curry_time_args, **curry_time_kwds, &blk)
      curry_data.curried
    end

    def compiletime_args(positions)
      CompiletimeArgs.new(positions)
    end
    alias_method :ct_args, :compiletime_args

    def runtime_arg(*args)
      RuntimeArg.new(*args)
    end
    alias_method :rt_arg, :runtime_arg
  end
end

