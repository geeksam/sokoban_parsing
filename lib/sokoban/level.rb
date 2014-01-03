module Sokoban
  class Level
    class Cell
      def initialize(contents = nil)
        @contents = contents
      end

      attr_reader :contents
    end

    class Floor < Cell
    end

    class Goal < Cell
    end

    class Wall < Cell
      def reachable?; false; end
    end

    class Void < Cell
    end

    class Character; end
    class Crate; end

    def initialize(rows)
      @rows = rows
    end

    attr_reader :rows

    def [](x, y)
      rows[y][x]
    end
  end
end
