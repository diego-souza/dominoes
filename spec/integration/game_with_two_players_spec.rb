require 'dominoes'
describe "Game with two players" do

  context "generic first player actions" do
    before(:each) do
      @players = ["Diego", "Hugo"]
      @game = Game.new :players => @players
      @current_player_name = @game.current_player.name
    end

    it "its players should have the names indicated" do
      @game.players.map{|p| p.name}.should =~ @players 
    end

    it "current player plays a stone" do
      stone = @game.current_player.doubles.last
      @game.play stone
      @game.playground.area.should == [stone.first_number, stone.second_number]
      new_current_player_name = @game.current_player.name
      @players.should =~ [@current_player_name, new_current_player_name]
    end

    it "current player plays stone he does not own" do
      stone = @game.stock.first
      lambda {@game.play stone}.should raise_error PlayerDoesNotOwnStone
      @game.playground.area.should == []
      @game.current_player.name.should == @current_player_name
    end

    it "current player plays stone that does not match" do
      @game.play @game.current_player.doubles.last
      possible_stones = @game.current_player.hand.dup
      edges = [@game.playground.area.first, @game.playground.area.last]
      possible_stones.delete_if{|s| edges.include?(s.first_number) || edges.include?(s.second_number)}
      old_playground_area = @game.playground.area
      old_current_player_name = @game.current_player.name

      lambda {@game.play possible_stones.first}.should raise_error CantPlayStone
      @game.current_player.name.should == old_current_player_name
      @game.playground.area.should == old_playground_area 
    end

    it "current player buys all stones" do
      old_stock = @game.stock.dup
      old_hand = @game.current_player.hand
      @game.stock.size.times do
        @game.buy
      end
      @game.stock.should be_empty
      @game.current_player.hand.should =~ old_stock + old_hand
    end

    it "current player passes" do
      lambda { @game.pass }.should raise_error PlayerMustBuyOrPlay
    end

    it "current player buys all stones and passes" do
      @game.stock.size.times do
        @game.buy
      end
      @game.pass
      @game.playground.area.should == []
      new_current_player_name = @game.current_player.name
      @players.should =~ [@current_player_name, new_current_player_name]
    end

    it "current player buys all stones and buy another" do
      @game.stock.size.times do
        @game.buy
      end
      lambda { @game.buy }.should raise_error StockIsEmpty
    end
  end

  context "beginning game" do
    before(:each) do
      @players = ["Diego", "Hugo"]
      basic_stones = (0..6).to_a.repeated_combination(2).to_a
      Game::BASIC_STONES.should_receive(:shuffle).and_return(basic_stones.dup) 
      # Diego [[3, 6], [4, 4], [4, 5], [4, 6], [5, 5], [5, 6], [6, 6]]
      # Hugo  [[2, 3], [2, 4], [2, 5], [2, 6], [3, 3], [3, 4], [3, 5]]
      @diegos_hand = basic_stones.pop(7)
      @hugos_hand = basic_stones.pop(7)
      @game = Game.new :players => @players
      @current_player_name = @game.current_player.name
    end

    it "checking game setup" do
      diego = @game.current_player
      diego.name.should == "Diego"
      diego.hand.each do |stone|
        @diegos_hand.should include [stone.first_number, stone.second_number]
      end
      hugo = (@game.players - [@game.current_player]).first
      hugo.name.should == "Hugo"
      hugo.hand.each do |stone|
        @hugos_hand.should include [stone.first_number, stone.second_number]
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
        @game.playground.area.should == [6, 6]
      end

      context "Second player plays - Hugo plays [2,6]" do
        # Diego [[3, 6], [4, 4], [4, 5], [4, 6], [5, 5], [5, 6]]
        # Hugo  [[2, 3], [2, 4], [2, 5], [2, 6], [3, 3], [3, 4], [3, 5]]
        before(:each) do
          stone = @game.current_player.hand[3]
          @game.play stone
        end

        it "playground area should have two stones" do
          @game.playground.area.should == [6, 6, 6, 2]
        end

        context "First player plays second time - Diego plays [5,6] on left" do
          # Diego [[3, 6], [4, 4], [4, 5], [4, 6], [5, 5], [5, 6]]
          # Hugo  [[2, 3], [2, 4], [2, 5], [3, 3], [3, 4], [3, 5]]
          before(:each) do
            stone = @game.current_player.hand.last
            @game.play stone, :first
          end

          it "playground area should have two stones" do
            @game.playground.area.should == [5, 6, 6, 6, 6, 2]
          end

          context "Playing a double stone" do
            it "should have 6 stones in play" do
              # Diego [[3, 6], [4, 4], [4, 5], [4, 6], [5, 5]]
              # Hugo  [[2, 3], [2, 4], [2, 5], [3, 3], [3, 4], [3, 5]]
              stone = @game.current_player.hand[2]
              @game.play stone, :last
              @game.playground.area.should == [5, 6, 6, 6, 6, 2, 2, 5]

              # Diego [[3, 6], [4, 4], [4, 5], [4, 6], [5, 5]]
              # Hugo  [[2, 3], [2, 4], [3, 3], [3, 4], [3, 5]]
              stone = @game.current_player.hand.last
              @game.play stone, :last
              @game.playground.area.should == [5, 6, 6, 6, 6, 2, 2, 5, 5, 5]
            end
          end

        end


      end
    end
  end
end
