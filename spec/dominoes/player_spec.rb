require 'dominoes/player'
describe Player do
  describe "basic attributes" do
    it "should have a name" do
      player = Player.new :name => "Diego"
      expect(player.name).to eq("Diego")
    end

    it "should have a hand" do
      hand = double
      player = Player.new :hand => hand
      expect(player.hand).to eq(hand) 
    end

    it "hand should be empty if not initialized" do
      player = Player.new
      expect(player.hand).to be_empty
    end
  end

  describe "receive stones" do
    it "should add stone to player's hand" do
      player = Player.new
      stone = double
      stone.stub(:to_a => [stone])
      player.receive_stones stone
      expect(player.hand).to eq([stone])
    end

    it "should add several stones to player's hand" do
      player = Player.new
      stone = double
      other_stone = double
      stones = [stone, other_stone]
      player.receive_stones stones
      expect(player.hand).to match_array([stone, other_stone])
    end
  end

  describe "give stone" do
    it "should remove stone from player's hand" do
      player = Player.new
      stone = double
      stone.stub(:to_a => [stone])
      player.receive_stones [stone]
      player.give_stones stone
      expect(player.hand).to eq([])
    end

    it "should remove several stones from player's hand" do
      player = Player.new
      stone = double
      other_stone = double
      stones = [stone, other_stone]
      player.receive_stones stones
      player.give_stones stones
      expect(player.hand).to match_array([])
    end
  end

  describe "doubles" do
    it "should return all stones that are doubles" do
      double_stone = double(:double? => true)
      regular_stone = double(:double? => false)
      stones = [double_stone, regular_stone]
      player = Player.new
      player.receive_stones stones
      expect(player.doubles).to eq([double_stone])
    end

    it "should return empty array if none stones are doubles" do
      double_stone = double(:double? => false)
      regular_stone = double(:double? => false)
      stones = [double_stone, regular_stone]
      player = Player.new
      player.receive_stones stones
      expect(player.doubles).to eq([])
    end
  end

  describe "has_double?" do
    it "should be true if any of its stones is double" do
      stones = [double(:double? => false), double(:double? => true)]
      player = Player.new
      player.receive_stones stones
      expect(player.has_double?).to be_truthy
    end

    it "should be false if none of its stones is double" do
      stones = [double(:double? => false), double(:double? => false)]
      player = Player.new
      player.receive_stones stones
      expect(player.has_double?).to be_falsey
    end
  end

  describe "max_double" do
    it "should return -1 if has no doubles" do
      stones = [double(:double? => false), double(:double? => false)]
      player = Player.new
      player.receive_stones stones
      expect(player.max_double).to eq(-1)
    end

    it "should return biggest number of doubles if has doubles" do
      stones = [double(:double? => true, :first_number => 1, :second_number => 1), double(:double? => true, :first_number => 2, :second_number => 2)]
      player = Player.new
      player.receive_stones stones
      expect(player.max_double).to eq(2)
    end
  end

  describe "has_stone?" do
    it "should return true if has stone" do
      stone = double
      stones = [stone]
      player = Player.new
      player.receive_stones stones
      expect(player.has_stone?(stone)).to eq(true)
    end

    it "should return false if does not have stone" do
      stone = double
      another_stone = double
      stones = [another_stone]
      player = Player.new
      player.receive_stones stones
      expect(player.has_stone?(stone)).to eq(false)
    end
  end

  describe "has_matching_stone?" do
    it "should be false if stones in hand do not match any argument" do
      number = double
      stone = double
      expect(stone).to receive(:matches?).with(number).and_return(false)
      stones = [stone]
      player = Player.new
      player.receive_stones stones
      expect(player.has_matching_stone?(number)).to eq(false)
    end

    it "should be true if any stone in hand match any argument" do
      number = double
      matching_stone = double
      stone = double
      expect(matching_stone).to receive(:matches?).with(number).and_return(true)
      expect(stone).to receive(:matches?).with(number).and_return(false)
      stones = [stone, matching_stone]
      player = Player.new
      player.receive_stones stones
      expect(player.has_matching_stone?(number)).to eq(true)
    end

  end

end
