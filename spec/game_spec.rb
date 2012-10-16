require 'game'
describe Game do

  describe "basic attributes" do
    before(:each) do
      @players = ["Diego", "Hugo"]
      @game = Game.new :players => @players
    end

    it "should have a default set of stones" do
      Game::BASIC_STONES
    end

    it "should have players" do
      @game.should respond_to :players
    end

    it "should have current player" do
      @game.should respond_to :current_player
    end

    it "should have a stock" do
      @game.should respond_to :stock
    end

    it "should have a board" do
      @game.should respond_to :playground
    end

    it "must have at least 2 players" do
      players = []
      lambda { Game.new :players => players }.should raise_error NotEnoughPlayers
      players = ["diego"]
      lambda { Game.new :players => players }.should raise_error NotEnoughPlayers
      players = ["diego", "hugo"]
      lambda { Game.new :players => players }.should_not raise_error NotEnoughPlayers
      game = Game.new :players => players
      game.players.map{|p| p.name}.should == players
    end
  end

  describe "setup" do
    it "should distribute seven stones to each player" do
      game = Game.new :players => ["diego", "hugo"]
      game.players.first.hand.size.should == 7
      game.players.last.hand.size.should == 7
    end

    it "should assign player with bigest double to current player" do
      diego = stub(:name => "Diego")
      Rules.should_receive(:player_with_bigest_double).and_return(diego)
      game = Game.new :players => ["diego", "hugo"]
      game.current_player.should == diego
    end

    it "should should redistribute stones if no one has doubles" do
      diego = stub(:name => "Diego")
      Rules.should_receive(:player_with_bigest_double).once.and_return(nil)
      Rules.should_receive(:player_with_bigest_double).once.and_return(diego)
      game = Game.new :players => ["diego", "hugo"]
      game.current_player.should == diego
      game.stock.size.should == 14
      game.players.first.hand.size.should == 7
      game.players.last.hand.size.should == 7
    end
  end

  describe "playing" do
    before(:each) do
      @game = Game.new :players => ["diego", "hugo"]
      @next_player = stub
      Rules.stub(:next_player => @next_player)
    end

    it "current player can play a stone he owns" do
      stone = stub
      @game.current_player.should_receive(:has_stone?).with(stone).and_return(true)
      @game.playground.should_receive(:play_stone).with(stone)
      @game.current_player.should_receive(:give_stones).with(stone).and_return(false)
      lambda { @game.play stone }.should_not raise_error PlayerDoesNotOwnStone
      @game.current_player.should == @next_player
    end

    it "current player can not play a stone he does not owns" do
      stone = stub
      @game.current_player.should_receive(:has_stone?).with(stone).and_return(false)
      @game.playground.should_not_receive(:play_stone).with(stone)
      @game.current_player.should_not_receive(:give_stones).with(stone).and_return(false)
      lambda { @game.play stone }.should raise_error PlayerDoesNotOwnStone
      @game.current_player.should_not == @next_player
    end

    context "stock is not empty" do
      before(:each) do
        @game.stock.should_receive(:empty?).and_return(false)
      end

      it "current player can buy a stone from stock" do
        stone = stub
        @game.stock.should_receive(:first).and_return(stone)
        @game.current_player.should_receive(:receive_stones).with(stone)
        lambda { @game.buy }.should_not raise_error StockIsEmpty
      end

      it "current player can not pass" do
        lambda { @game.pass }.should raise_error PlayerMustBuyOrPlay
        @game.current_player.should_not == @next_player
      end
    end

    context "stock is empty" do
      before(:each) do
        @game.stock.should_receive(:empty?).and_return(true)
      end

      it "current player can not buy a stone from stock" do
        @game.stock.should_not_receive(:first)
        @game.current_player.should_not_receive(:receive_stones)
        lambda { @game.buy }.should raise_error StockIsEmpty
      end

      it "current player can pass" do
        lambda { @game.pass }.should_not raise_error PlayerMustBuyOrPlay
        @game.current_player.should == @next_player
      end
    end
  end
end
