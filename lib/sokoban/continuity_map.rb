module Sokoban
  class ContinuityMap
    def self.for_level(rows)
      new_rows = rows.map {|row|
        row.map {|cell|
          case
          when cell.occupied? ; '+'
          when cell.passable? ; ' '
          else                ; '-'
          end
        }
      }
      new(new_rows)
    end

    def initialize(rows)
      @rows = rows
    end

    attr_reader :rows

    def fixed_point
      if self.to_s == succ.to_s
        self
      else
        succ.fixed_point
      end
    end

    def succ
      succ_rows = rows.map.with_index {|row, y|
        row.map.with_index {|cell, x|
          case cell
          when '+', '-' then cell
          else
            n = Array(rows[ y + 1 ])[ x + 0 ]
            s = Array(rows[ y - 1 ])[ x + 0 ]
            e = Array(rows[ y + 0 ])[ x + 1 ]
            w = Array(rows[ y + 0 ])[ x - 1 ]

            [n, s, e, w].compact.detect {|c| c == '+' } || cell
          end
        }
      }
      self.class.new(succ_rows)
    end

    def to_s
      rows.map(&:join).join("\n")
    end

    def each(&b)
      rows.each(&b)
    end
  end
end
