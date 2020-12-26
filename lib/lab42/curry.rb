module Lab42
  module Curry
    def curry(method_or_name, *curry_time_args, &blk)
      case method_or_name
      when Symbol
        _curry(method(method_or_name), *curry_time_args, &blk)
      else
        _curry(method_or_name, *curry_time_args, &blk)
      end
    end

    private
    def _curry(mthd, *ct_args, &blk)
    ->(*rt_args) { mthd.(*(ct_args + rt_args)) }
    end
  end
end

