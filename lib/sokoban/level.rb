module Sokoban
  class Level
    class Cell
      def initialize(contents = nil, level = nil)
        @contents = contents
        @level    = level
      end

      attr_reader :contents, :level

      def in_level(level)
        self.class.new(contents, level)
      end

      def reachable?
        !!@reachable
      end

      def reachable!
        return if @reachable
        @reachable = true
        level.neighbors_of(self).each(&:reachable!)
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
      def reachable!; end
    end

    class Void < Cell
      def reachable!; end
    end

    class Character; end
    class Crate; end

    def initialize(rows)
      @rows = rows.map {|row|
        row.map {|cell| cell.in_level(self) }
      }
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

    def with_reachability
      level = dup
      level.determine_reachability!
      rows_prime = level.rows.map {|row|
        row.map {|cell| void_warranty_on(cell) }
      }
      self.class.new(rows_prime)
    end

    protected

    def void_warranty_on(cell)
      if cell.kind_of?(Floor) && !cell.reachable?
        Void.new
      else
        cell.class.new(cell.contents)
      end
    end

    def determine_reachability!
      starting_cell.reachable!
    end
  end
end
