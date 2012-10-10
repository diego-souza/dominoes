require 'player'
describe Player do
  describe "basic attributes" do
    it "should have a name" do
      player = Player.new :name => "Diego"
      player.name.should == "Diego"
    end

    it "should have a hand" do
      hand = stub
      player = Player.new :hand => hand
      player.hand.should == hand 
    end

    it "hand should be empty if not initialized" do
      player = Player.new
      player.hand.should be_empty
    end
  end

  describe "receive stones" do
    it "should add stone to player's hand" do
      player = Player.new
      stone = stub
      stone.stub(:to_a => [stone])
      player.receive_stones stone
      player.hand.should == [stone]
    end

    it "should add several stones to player's hand" do
      player = Player.new
      stone = stub
      other_stone = stub
      stones = [stone, other_stone]
      player.receive_stones stones
      player.hand.should =~ [stone, other_stone]
    end
  end

  describe "give stone" do
    it "should remove stone from player's hand" do
      player = Player.new
      stone = stub
      stone.stub(:to_a => [stone])
      player.receive_stones [stone]
      player.give_stones stone
      player.hand.should == []
    end

    it "should remove several stones from player's hand" do
      player = Player.new
      stone = stub
      other_stone = stub
      stones = [stone, other_stone]
      player.receive_stones stones
      player.give_stones stones
      player.hand.should =~ []
    end
  end

  describe "doubles" do
    it "should return all stones that are doubles" do
      double_stone = stub(:double? => true)
      regular_stone = stub(:double? => false)
      stones = [double_stone, regular_stone]
      player = Player.new
      player.receive_stones stones
      player.doubles.should == [double_stone]
    end

    it "should return empty array if none stones are doubles" do
      double_stone = stub(:double? => false)
      regular_stone = stub(:double? => false)
      stones = [double_stone, regular_stone]
      player = Player.new
      player.receive_stones stones
      player.doubles.should == []
    end
  end

  describe "has_double?" do
    it "should be true if any of its stones is double" do
      stones = [stub(:double? => false), stub(:double? => true)]
      player = Player.new
      player.receive_stones stones
      player.has_double?.should be_true
    end

    it "should be false if none of its stones is double" do
      stones = [stub(:double? => false), stub(:double? => false)]
      player = Player.new
      player.receive_stones stones
      player.has_double?.should be_false
    end
  end

  describe "max_double" do
    it "should return -1 if has no doubles" do
      stones = [stub(:double? => false), stub(:double? => false)]
      player = Player.new
      player.receive_stones stones
      player.max_double.should == -1
    end

    it "should return biggest number of doubles if has doubles" do
      stones = [stub(:double? => true, :first_number => 1, :second_number => 1), stub(:double? => true, :first_number => 2, :second_number => 2)]
      player = Player.new
      player.receive_stones stones
      player.max_double.should == 2
    end
  end

end
