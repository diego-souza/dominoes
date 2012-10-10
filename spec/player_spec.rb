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
end
