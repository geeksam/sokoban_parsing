require_relative "level"
require_relative "continuity_map"

module Sokoban
  class Parser
    MAP_MAPPING = {
      "@" => ->(*) { Level::Floor.new(Level::Character.new) },
      " " => ->(*) { Level::Floor.new },
      "$" => ->(*) { Level::Floor.new(Level::Crate.new) },
      "." => ->(*) { Level::Goal.new },
      "*" => ->(*) { Level::Goal.new(Level::Crate.new) },
      "#" => ->(*) { Level::Wall.new },
      "!" => ->(*) { Level::Void.new },
    }
    MAP_MAPPING.default = ->(c) { raise "Unrecognized character #{c.inspect}" }

    def self.parse(map)
      new(map).to_level
    end

    def initialize(map)
      @map = map
    end

    attr_reader :map

    def to_level
      rows = void_unreachable_floor_tiles(bare_rows)
      Sokoban::Level.new(rows)
    end

    private

    def bare_rows
      map.lines.map { |line|
        normalize(line).chars.map {|c| parse_char(c) }
      }
    end

    def void_unreachable_floor_tiles(rows)
      cm = ContinuityMap.for_level(rows).fixed_point
      rows.zip(cm).map {|row, cm_row|
        row.zip(cm_row).map {|cell, cm_cell|
          if cell.kind_of?(Level::Floor) && cm_cell == ' '
            Level::Void.new
          else
            cell
          end
        }
      }
    end

    def parse_char(c)
      MAP_MAPPING[c].call(c)
    end

    def normalize(line)
      line.strip.ljust(length_of_longest_line, '!')
    end

    def length_of_longest_line
      map.lines.map(&:length).max
    end
  end
end
