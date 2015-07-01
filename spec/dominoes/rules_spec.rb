require 'dominoes/rules'
describe Rules do
  describe "player_with_bigest_double" do
    it "should return player with biggest double" do
      first_player = double(:max_double => 1)
      second_player = double(:max_double => 2)
      players = [first_player, second_player]
      expect(Rules.player_with_bigest_double(players)).to eq(second_player)
    end

    it "should return nil if players have no doubles" do
      first_player = double(:max_double => -1)
      second_player = double(:max_double => -1)
      players = [first_player, second_player]
      expect(Rules.player_with_bigest_double(players)).to eq(nil)
    end
  end

  describe "next_player" do
    before(:each) do
      @current_player = double
      @next_player = double
    end
    it "should be the player at right of current_player" do
      players = [@current_player, @next_player]
      expect(Rules.next_player(players, @current_player)).to eq(@next_player)

      another_player = double
      players = [@current_player, @next_player, another_player]
      expect(Rules.next_player(players, @current_player)).to eq(@next_player)
    end

    it "should be the first player if current_player is the last" do
      players = [@next_player, @current_player]
      expect(Rules.next_player(players, @current_player)).to eq(@next_player)

      another_player = double
      players = [@next_player, another_player, @current_player]
      expect(Rules.next_player(players, @current_player)).to eq(@next_player)
    end
  end

  describe "winner" do
    it "should return player if has empty hand" do
      first_player = double(:hand => [])
      second_player = double(:hand => [double])
      players = [first_player, second_player]
      expect(Rules.winner(players)).to eq(first_player)
    end

    it "should return nil if no one has empty hand" do
      first_player = double(:hand => [double])
      second_player = double(:hand => [double])
      players = [first_player, second_player]
      expect(Rules.winner(players)).to eq(nil)
    end
  end

  describe "winner?" do
    it "should return true if has winner" do
      players = double
      expect(Rules).to receive(:winner).with(players).and_return([double])
      expect(Rules.winner?(players)).to be_truthy
    end

    it "should return false if has no winner" do
      players = double
      expect(Rules).to receive(:winner).with(players).and_return([])
      expect(Rules.winner?(players)).to be_falsey
    end
  end

  describe "game_over?" do
    before(:each) do
      @players, @stock, @edges = double, double, double
    end
    it "should be true when there is a winner" do
      expect(Rules).to receive(:winner?).with(@players).and_return(true)
      expect(Rules.game_over?(@players, @stock, @edges)).to be_truthy
    end

    context "there is no winner" do
      before(:each) do
        expect(Rules).to receive(:winner?).and_return(false)
      end

      it "should be false when there are stones in stock" do
        @stock = double(:any? => true)
        expect(Rules.game_over?(@players, @stock, @edges)).to be_falsey
      end

      context "there are not stones in stock" do
        before(:each) do
          @stock = double(:any? => false)
        end

        it "should be false when game is not stuck" do
          Rules.stub(:stuck? => false)
          expect(Rules.game_over?(@players, @stock, @edges)).to be_falsey
        end

        it "should be true when game is stuck" do
          Rules.stub(:stuck? => true)
          expect(Rules.game_over?(@players, @stock, @edges)).to be_truthy
        end
      end
    end
  end

  describe "stuck?" do
    before(:each) do
      @first_player, @second_player = double, double
      @players = [@first_player, @second_player]
      @first_edge, @second_edge = double, double
      @edges = [@first_edge, @second_edge]
    end

    it "should be false if any player has matching stone for first edge" do
      expect(@first_player).to receive(:has_matching_stone?).with(@first_edge).and_return(true)

      expect(Rules.stuck?(@players, @edges)).to be_falsey
    end

    it "should be false if any player has matching stone for second edge" do
      expect(@first_player).to receive(:has_matching_stone?).with(@first_edge).and_return(false)
      expect(@first_player).to receive(:has_matching_stone?).with(@second_edge).and_return(true)

      expect(Rules.stuck?(@players, @edges)).to be_falsey
    end

    it "should be true if no players have matching stone" do
      expect(@first_player).to receive(:has_matching_stone?).with(@first_edge).and_return(false)
      expect(@first_player).to receive(:has_matching_stone?).with(@second_edge).and_return(false)
      expect(@second_player).to receive(:has_matching_stone?).with(@first_edge).and_return(false)
      expect(@second_player).to receive(:has_matching_stone?).with(@second_edge).and_return(false)
      
      expect(Rules.stuck?(@players, @edges)).to be_truthy
    end
  end
end
