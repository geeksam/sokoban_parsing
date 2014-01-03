module Sokoban
  class Level
    class Cell
      def initialize(contents = nil)
        @contents = contents
      end

      attr_reader :contents

      def occupied?
        contents.kind_of?(Character)
      end

      def passable?
        true
      end

      def inspect
        s = self.class.to_s.split('::').last
        s.upcase! if occupied?
        s
      end
    end

    class Floor < Cell
    end

    class Goal < Cell
    end

    class Wall < Cell
      def passable? ; false ; end
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

    def neighbors_of(cell)
      x, y = *coordinates_of(cell)

      # FIXME: add boundary checking; technically, this wraps around.
      # Fortunately, there's always a wall around the outside, so for
      # purposes of just marking cells as reachable, it doesn't matter.
      n = [ x + 0 , y + 1 ]
      s = [ x + 0 , y - 1 ]
      e = [ x + 1 , y + 0 ]
      w = [ x - 1 , y + 0 ]

      [n, e, s, w].compact.map {|x, y| self[x, y] }
    end

    def coordinates_of(cell)
      y = rows.index {|row| row.include?(cell) }
      x = rows[y].index(cell)
      [x, y]
    end

    def starting_cell
      rows.flatten.detect {|cell| cell.contents.kind_of?(Character) }
    end
  end
end
