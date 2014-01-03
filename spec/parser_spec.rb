require_relative "../lib/sokoban/parser"

describe Sokoban::Parser do
  context "basic parsing" do
    let(:minimal_map) {
      <<-END_MAP.gsub(/^\s*/, "")
      #######
      #@ $.*#
      #######
      END_MAP
    }
    let(:minimal_level) { Sokoban::Parser.parse(minimal_map) }

    it "parses maps into levels" do
      expect(minimal_level).to be_an_instance_of(Sokoban::Level)
    end

    it "parses the character" do
      expect(minimal_level[1, 1]).to be_an_instance_of(Sokoban::Level::Floor)
      expect(minimal_level[1, 1].contents).to be_an_instance_of(Sokoban::Level::Character)
    end

    it "parses open floor" do
      expect(minimal_level[2, 1]).to be_an_instance_of(Sokoban::Level::Floor)
      expect(minimal_level[2, 1].contents).to be_nil
    end

    it "parses a crate" do
      expect(minimal_level[3, 1]).to be_an_instance_of(Sokoban::Level::Floor)
      expect(minimal_level[3, 1].contents).to be_an_instance_of(Sokoban::Level::Crate)
    end

    it "parses an unsatisfied goal" do
      expect(minimal_level[4, 1]).to be_an_instance_of(Sokoban::Level::Goal)
      expect(minimal_level[4, 1].contents).to be_nil
    end

    it "parses a satisfied goal" do
      expect(minimal_level[5, 1]).to be_an_instance_of(Sokoban::Level::Goal)
      expect(minimal_level[5, 1].contents).to be_an_instance_of(Sokoban::Level::Crate)
    end
  end

  context "irregular levels" do
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

    it "pads the outsides of the level" do
      expect(irregular_level.rows.all? { |r| r.size == irregular_level.rows.first.size }).to be_true
    end

    it "pads with void" do
      expect(irregular_level[3, 0]).to be_kind_of(Sokoban::Level::Void)
      expect(irregular_level[4, 0]).to be_kind_of(Sokoban::Level::Void)
    end
  end
end
