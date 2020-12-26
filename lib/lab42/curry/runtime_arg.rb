module Lab42
  module Curry
    class RuntimeArg
      attr_reader :position

      private
      def initialize(position = nil)
        @position = position
      end
    end
  end
end
