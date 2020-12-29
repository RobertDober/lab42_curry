module Lab42
  module Curry
    class ComputedArg
      
      def with_position(final_position)
        @final_position = final_position
        self
      end

      private
      def initialize(blk)
        @blk = blk
      end
    end
  end
end
