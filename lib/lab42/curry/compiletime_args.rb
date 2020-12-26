module Lab42
  module Curry
    class CompiletimeArgs
      include Enumerable

      attr_reader :positions

      def each
        positions.each { yield _1 }
      end

      private
      def initialize positions
        @positions = positions
      end
    end
  end
end
