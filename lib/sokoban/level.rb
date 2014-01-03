module Sokoban
  class Level
    class Cell
      def initialize(contents = nil, level = nil)
        @contents = contents
        @level    = level
      end

      attr_reader :contents, :level

      def reachable?
        @reachable ||=
          contents.kind_of?(Character) || neighbors.any?(&:reachable?) ||
          :nope
        return false if @reachable == :nope
        @reachable
      end

      def in_level(level)
        self.class.new(contents, level)
      end

      def neighbors
        level.neighbors_of(self) #.tap {|x| require 'pp'; puts; pp x }
      end

      def inspect
        s = self.class.to_s.split('::').last
        s.upcase! if contents.kind_of?(Character)
        s
      end
    end

    class Floor < Cell
    end

    class Goal < Cell
    end

    class Wall < Cell
      def reachable?; false; end
    end

    class Void < Cell
      def reachable?; false; end
    end

    class Character; end
    class Crate; end

    def initialize(rows)
      @rows = rows.map {|row| row.map {|cell| cell.in_level(self) } }
    end

    attr_reader :rows

    def [](x, y)
      rows[y][x]
    end

    def neighbors_of(cell)
      y = rows.index {|row| row.include?(cell) }
      x = rows[y].index(cell)

      cardinal_neighbors(x, y)
    end

    def cardinal_neighbors(x, y)
      n = self[ x   , y-1 ]
      e = self[ x+1 , y   ]
      s = self[ x   , y+1 ]
      w = self[ x-1 , y   ]

      [n, e, s, w].compact
    end
  end
end
