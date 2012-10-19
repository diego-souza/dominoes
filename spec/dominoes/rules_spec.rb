require 'dominoes/rules'
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

  describe "next_player" do
    before(:each) do
      @current_player = stub
      @next_player = stub
    end
    it "should be the player at right of current_player" do
      players = [@current_player, @next_player]
      Rules.next_player(players, @current_player).should == @next_player

      another_player = stub
      players = [@current_player, @next_player, another_player]
      Rules.next_player(players, @current_player).should == @next_player
    end

    it "should be the first player if current_player is the last" do
      players = [@next_player, @current_player]
      Rules.next_player(players, @current_player).should == @next_player

      another_player = stub
      players = [@next_player, another_player, @current_player]
      Rules.next_player(players, @current_player).should == @next_player
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

  describe "game_over?" do
    before(:each) do
      @players, @stock, @edges = stub, stub, stub
    end
    it "should be true when there is a winner" do
      Rules.should_receive(:winner?).with(@players).and_return(true)
      Rules.game_over?(@players, @stock, @edges).should be_true
    end

    context "there is no winner" do
      before(:each) do
        Rules.should_receive(:winner?).and_return(false)
      end

      it "should be false when there are stones in stock" do
        @stock = stub(:any? => true)
        Rules.game_over?(@players, @stock, @edges).should be_false
      end

      context "there are not stones in stock" do
        before(:each) do
          @stock = stub(:any? => false)
        end

        it "should be false when game is not stuck" do
          Rules.stub(:stuck? => false)
          Rules.game_over?(@players, @stock, @edges).should be_false
        end

        it "should be true when game is stuck" do
          Rules.stub(:stuck? => true)
          Rules.game_over?(@players, @stock, @edges).should be_true
        end
      end
    end
  end

  describe "stuck?" do
    before(:each) do
      @first_player, @second_player = mock, mock
      @players = [@first_player, @second_player]
      @first_edge, @second_edge = mock, mock
      @edges = [@first_edge, @second_edge]
    end

    it "should be false if any player has matching stone for first edge" do
      @first_player.should_receive(:has_matching_stone?).with(@first_edge).and_return(true)

      Rules.stuck?(@players, @edges).should be_false
    end

    it "should be false if any player has matching stone for second edge" do
      @first_player.should_receive(:has_matching_stone?).with(@first_edge).and_return(false)
      @first_player.should_receive(:has_matching_stone?).with(@second_edge).and_return(true)

      Rules.stuck?(@players, @edges).should be_false
    end

    it "should be true if no players have matching stone" do
      @first_player.should_receive(:has_matching_stone?).with(@first_edge).and_return(false)
      @first_player.should_receive(:has_matching_stone?).with(@second_edge).and_return(false)
      @second_player.should_receive(:has_matching_stone?).with(@first_edge).and_return(false)
      @second_player.should_receive(:has_matching_stone?).with(@second_edge).and_return(false)
      
      Rules.stuck?(@players, @edges).should be_true
    end
  end
end
