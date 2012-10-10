require 'rules'
describe Rules do
  describe "player_with_bigest_double" do
    it "should return player with biggest double" do
      first_player = stub(:max_double => 1)
      second_player = stub(:max_double => 2)
      players = [first_player, second_player]
      Rules.player_with_bigest_double(players).should == second_player
    end

    it "should return nil if players have no doubles" do
      first_player = stub(:max_double => -1)
      second_player = stub(:max_double => -1)
      players = [first_player, second_player]
      Rules.player_with_bigest_double(players).should == nil
    end
  end

  describe "winner" do
    it "should return player if has empty hand" do
      first_player = stub(:hand => [])
      second_player = stub(:hand => [stub])
      players = [first_player, second_player]
      Rules.winner(players).should == first_player
    end

    it "should return nil if no one has empty hand" do
      first_player = stub(:hand => [stub])
      second_player = stub(:hand => [stub])
      players = [first_player, second_player]
      Rules.winner(players).should == nil
    end
  end

  describe "winner?" do
    it "should return true if has winner" do
      players = stub
      Rules.should_receive(:winner).with(players).and_return([stub])
      Rules.winner?(players).should be_true
    end

    it "should return false if has no winner" do
      players = stub
      Rules.should_receive(:winner).with(players).and_return([])
      Rules.winner?(players).should be_false
    end
  end
end
