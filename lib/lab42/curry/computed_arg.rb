module Lab42
  module Curry
    class ComputedArg

      attr_reader :position

      def call(*args, **kwds)
        @blk.call(*args, **kwds)
      end
      
      private
      def initialize(position, blk)
        @blk = blk
        @position = position
      end
    end
  end
end
