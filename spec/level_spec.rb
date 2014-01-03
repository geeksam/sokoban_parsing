require_relative "../lib/sokoban/parser"

describe Sokoban::Level do
  describe "reachability" do
    let(:bifurcated_map) {
      <<-END_MAP.gsub(/^\s*/, "")
      #########
      #@ $.*# #
      #########
      END_MAP
    }
    let(:bifurcated_level) { Sokoban::Parser.parse(bifurcated_map) }

    specify "a Wall is not reachable" do
      expect(bifurcated_level[0, 0]).to_not be_reachable
    end

    # specify "a Void is not reachable" do
    #   expect(bifurcated_level[3, 0]).to_not be_reachable
    # end

    specify "other Cells are reachable if they contain a Character" do
      expect(bifurcated_level[1, 1]).to be_reachable
    end

    specify "other Cells are reachable if any of their neighbors is reachable" do
require 'pp'; puts
puts bifurcated_level.rows.map(&:inspect)
puts bifurcated_level.rows.map {|row| row.map(&:reachable?).inspect }
      expect(bifurcated_level[1, 1].contents).to be_an_instance_of(Sokoban::Level::Character)
      expect(bifurcated_level[1, 1]).to be_reachable

      expect(bifurcated_level[2, 1].contents).to be_nil
      expect(bifurcated_level[2, 1]).to be_reachable

      expect(bifurcated_level[3, 1].contents).to be_an_instance_of(Sokoban::Level::Crate)
      expect(bifurcated_level[3, 1]).to be_reachable

      expect(bifurcated_level[4, 1].contents).to be_nil
      expect(bifurcated_level[4, 1]).to be_reachable

      expect(bifurcated_level[6, 1].contents).to be_nil
      expect(bifurcated_level[6, 1]).to_not be_reachable
    end
  end
end
