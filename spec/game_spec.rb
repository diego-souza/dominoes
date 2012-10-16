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
end
