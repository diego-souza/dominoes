require 'dominoes/game'
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
      expect(@game).to respond_to :players
    end

    it "should have current player" do
      expect(@game).to respond_to :current_player
    end

    it "should have a stock" do
      expect(@game).to respond_to :stock
    end

    it "should have a board" do
      expect(@game).to respond_to :playground
    end

    it "must have at least 2 players" do
      players = []
      expect { Game.new :players => players }.to raise_error NotEnoughPlayers
      players = ["diego"]
      expect { Game.new :players => players }.to raise_error NotEnoughPlayers
      players = ["diego", "hugo"]
      expect { Game.new :players => players }.not_to raise_error
      game = Game.new :players => players
      expect(game.players.map{|p| p.name}).to eq(players)
    end
  end

  describe "setup" do
    it "should distribute seven stones to each player" do
      game = Game.new :players => ["diego", "hugo"]
      expect(game.players.first.hand.size).to eq(7)
      expect(game.players.last.hand.size).to eq(7)
    end

    it "should assign player with bigest double to current player" do
      diego = double(:name => "Diego")
      expect(Rules).to receive(:player_with_bigest_double).and_return(diego)
      game = Game.new :players => ["diego", "hugo"]
      expect(game.current_player).to eq(diego)
    end

    it "should should redistribute stones if no one has doubles" do
      diego = double(:name => "Diego")
      expect(Rules).to receive(:player_with_bigest_double).once.and_return(nil)
      expect(Rules).to receive(:player_with_bigest_double).once.and_return(diego)
      game = Game.new :players => ["diego", "hugo"]
      expect(game.current_player).to eq(diego)
      expect(game.stock.size).to eq(14)
      expect(game.players.first.hand.size).to eq(7)
      expect(game.players.last.hand.size).to eq(7)
    end
  end

  describe "playing" do
    before(:each) do
      @game = Game.new :players => ["diego", "hugo"]
      @next_player = double
      allow(Rules).to receive_messages(:next_player => @next_player)
    end

    it "current player can play a stone he owns" do
      stone = double
      expect(@game.current_player).to receive(:has_stone?).with(stone).and_return(true)
      expect(@game.playground).to receive(:play_stone).with(stone, anything())
      expect(@game.current_player).to receive(:give_stones).with(stone).and_return(false)
      expect { @game.play stone }.not_to raise_error
      expect(@game.current_player).to eq(@next_player)
    end

    it "current player can play a stone he owns on specific edge" do
      stone = double
      edge = double
      expect(@game.current_player).to receive(:has_stone?).with(stone).and_return(true)
      expect(@game.playground).to receive(:play_stone).with(stone, edge)
      expect(@game.current_player).to receive(:give_stones).with(stone).and_return(false)
      expect { @game.play stone, edge }.not_to raise_error
      expect(@game.current_player).to eq(@next_player)
    end

    it "current player can not play a stone he does not owns" do
      stone = double
      expect(@game.current_player).to receive(:has_stone?).with(stone).and_return(false)
      expect(@game.playground).not_to receive(:play_stone).with(stone)
      expect(@game.current_player).not_to receive(:give_stones).with(stone)
      expect { @game.play stone }.to raise_error PlayerDoesNotOwnStone
      expect(@game.current_player).not_to eq(@next_player)
    end

    context "stock is not empty" do
      before(:each) do
        expect(@game.stock).to receive(:empty?).and_return(false)
      end

      it "current player can buy a stone from stock" do
        stone = double
        expect(@game.stock).to receive(:shift).and_return(stone)
        expect(@game.current_player).to receive(:receive_stones).with(stone)
        expect { @game.buy }.not_to raise_error
      end

      it "current player can not pass" do
        expect { @game.pass }.to raise_error PlayerMustBuyOrPlay
        expect(@game.current_player).not_to eq(@next_player)
      end
    end

    context "stock is empty" do
      before(:each) do
        expect(@game.stock).to receive(:empty?).and_return(true)
      end

      it "current player can not buy a stone from stock" do
        expect(@game.stock).not_to receive(:shift)
        expect(@game.current_player).not_to receive(:receive_stones)
        expect { @game.buy }.to raise_error StockIsEmpty
      end

      it "current player can pass" do
        expect { @game.pass }.not_to raise_error
        expect(@game.current_player).to eq(@next_player)
      end
    end
  end
end
