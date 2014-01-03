require_relative "../lib/sokoban/parser"

describe Sokoban::Level do
  describe "reachability" do
    let(:irregular_map) {
      <<-END_MAP.gsub(/^\s*/, "")
      ###
      #@###
      # $.#
      #####
      END_MAP
    }
    let(:irregular_level) {
      Sokoban::Parser.parse(irregular_map)
    }

    specify "a Wall is not reachable" do
      expect(irregular_level[0, 0]).to_not be_reachable
    end

    specify "a Void is not reachable" do
      expect(irregular_level[3, 0]).to_not be_reachable
    end

    specify "other Cells are reachable if they contain a Character" do
      expect(irregular_level[1, 1]).to be_reachable
    end

    specify "other Cells are reachable if any of their neighbors is reachable"
  end
end
