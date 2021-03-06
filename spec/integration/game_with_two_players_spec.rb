require 'dominoes'
describe "Game with two players" do

  context "generic first player actions" do
    before(:each) do
      @players = ["Diego", "Hugo"]
      @game = Game.new :players => @players
      @current_player_name = @game.current_player.name
    end

    it "its players should have the names indicated" do
      expect(@game.players.map{|p| p.name}).to match_array(@players) 
    end

    it "current player plays a stone" do
      stone = @game.current_player.doubles.last
      @game.play stone
      expect(@game.playground.area).to eq([stone.first_number, stone.second_number])
      new_current_player_name = @game.current_player.name
      expect(@players).to match_array([@current_player_name, new_current_player_name])
    end

    it "current player plays stone he does not own" do
      stone = @game.stock.first
      expect {@game.play stone}.to raise_error PlayerDoesNotOwnStone
      expect(@game.playground.area).to eq([])
      expect(@game.current_player.name).to eq(@current_player_name)
    end

    it "current player plays stone that does not match" do
      @game.play @game.current_player.doubles.last
      possible_stones = @game.current_player.hand.dup
      edges = [@game.playground.area.first, @game.playground.area.last]
      possible_stones.delete_if{|s| edges.include?(s.first_number) || edges.include?(s.second_number)}
      old_playground_area = @game.playground.area
      old_current_player_name = @game.current_player.name

      expect {@game.play possible_stones.first}.to raise_error CantPlayStone
      expect(@game.current_player.name).to eq(old_current_player_name)
      expect(@game.playground.area).to eq(old_playground_area) 
    end

    it "current player buys all stones" do
      old_stock = @game.stock.dup
      old_hand = @game.current_player.hand
      @game.stock.size.times do
        @game.buy
      end
      expect(@game.stock).to be_empty
      expect(@game.current_player.hand).to match_array(old_stock + old_hand)
    end

    it "current player passes" do
      expect { @game.pass }.to raise_error PlayerMustBuyOrPlay
    end

    it "current player buys all stones and passes" do
      @game.stock.size.times do
        @game.buy
      end
      @game.pass
      expect(@game.playground.area).to eq([])
      new_current_player_name = @game.current_player.name
      expect(@players).to match_array([@current_player_name, new_current_player_name])
    end

    it "current player buys all stones and buy another" do
      @game.stock.size.times do
        @game.buy
      end
      expect { @game.buy }.to raise_error StockIsEmpty
    end
  end

  context "beginning game" do
    before(:each) do
      @players = ["Diego", "Hugo"]
      basic_stones = (0..6).to_a.repeated_combination(2).to_a
      expect(Game::BASIC_STONES).to receive(:shuffle).and_return(basic_stones.dup) 
      # Diego [[3, 6], [4, 4], [4, 5], [4, 6], [5, 5], [5, 6], [6, 6]]
      # Hugo  [[2, 3], [2, 4], [2, 5], [2, 6], [3, 3], [3, 4], [3, 5]]
      @diegos_hand = basic_stones.pop(7)
      @hugos_hand = basic_stones.pop(7)
      @game = Game.new :players => @players
      @current_player_name = @game.current_player.name
    end

    it "checking game setup" do
      diego = @game.current_player
      expect(diego.name).to eq("Diego")
      diego.hand.each do |stone|
        expect(@diegos_hand).to include [stone.first_number, stone.second_number]
      end
      hugo = (@game.players - [@game.current_player]).first
      expect(hugo.name).to eq("Hugo")
      hugo.hand.each do |stone|
        expect(@hugos_hand).to include [stone.first_number, stone.second_number]
      end
    end

    context "First player plays - Diego plays [6, 6]" do
      # Diego [[3, 6], [4, 4], [4, 5], [4, 6], [5, 5], [5, 6], [6, 6]]
      # Hugo  [[2, 3], [2, 4], [2, 5], [2, 6], [3, 3], [3, 4], [3, 5]]
      before(:each) do
        stone = @game.current_player.hand.last
        @game.play stone
      end

      it "playground area should have only one stone" do
        expect(@game.playground.area).to eq([6, 6])
      end

      context "Second player plays - Hugo plays [2,6]" do
        # Diego [[3, 6], [4, 4], [4, 5], [4, 6], [5, 5], [5, 6]]
        # Hugo  [[2, 3], [2, 4], [2, 5], [2, 6], [3, 3], [3, 4], [3, 5]]
        before(:each) do
          stone = @game.current_player.hand[3]
          @game.play stone
        end

        it "playground area should have two stones" do
          expect(@game.playground.area).to eq([6, 6, 6, 2])
        end

        context "First player plays second time - Diego plays [5,6] on left" do
          # Diego [[3, 6], [4, 4], [4, 5], [4, 6], [5, 5], [5, 6]]
          # Hugo  [[2, 3], [2, 4], [2, 5], [3, 3], [3, 4], [3, 5]]
          before(:each) do
            stone = @game.current_player.hand.last
            @game.play stone, :first
          end

          it "playground area should have two stones" do
            expect(@game.playground.area).to eq([5, 6, 6, 6, 6, 2])
          end

          context "Playing a double stone" do
            it "should have 6 stones in play" do
              # Diego [[3, 6], [4, 4], [4, 5], [4, 6], [5, 5]]
              # Hugo  [[2, 3], [2, 4], [2, 5], [3, 3], [3, 4], [3, 5]]
              stone = @game.current_player.hand[2]
              @game.play stone, :last
              expect(@game.playground.area).to eq([5, 6, 6, 6, 6, 2, 2, 5])

              # Diego [[3, 6], [4, 4], [4, 5], [4, 6], [5, 5]]
              # Hugo  [[2, 3], [2, 4], [3, 3], [3, 4], [3, 5]]
              stone = @game.current_player.hand.last
              @game.play stone, :last
              expect(@game.playground.area).to eq([5, 6, 6, 6, 6, 2, 2, 5, 5, 5])
            end
          end

        end


      end
    end
  end
end
