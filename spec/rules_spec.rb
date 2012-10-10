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
end
