require 'playground'
describe Playground do
  it "should have empty area at the beginning" do
    playground = Playground.new
    playground.area.should == []
  end
  describe "play" do
    it "should accept first stone if double" do
      stone = stub(:double? => true, 
                   :first_number => 6,
                   :second_number => 6)
      playground = Playground.new
      playground.play_stone stone
      playground.area.should == [6, 6]
    end

    context "when there is a 6/6 stone players" do
      before(:each) do
        stone = stub(:double? => true, 
                     :first_number => 6,
                     :second_number => 6)
        @playground = Playground.new
        @playground.play_stone stone
      end
      it "should accept second stone if first_number matches edges" do
        second_stone = stub(:first_number => 6,
                            :second_number => 1)
        @playground.play_stone second_stone, :right
        @playground.area.should == [6, 6, 6, 1]
      end

      it "should accept second stone if second_number matches edges" do
        second_stone = stub(:first_number => 1,
                            :second_number => 6)
        @playground.play_stone second_stone, :right
        @playground.area.should == [6, 6, 6, 1]
      end

      it "should raise error if no number matches edges" do
        second_stone = stub(:first_number => 1,
                            :second_number => 1)
        lambda {@playground.play_stone second_stone, :right}.should raise_error CantPlayStone
        @playground.area.should == [6, 6]
      end

      context "and there is a 6/1 stone played" do
        before(:each) do
          second_stone = stub(:first_number => 1,
                              :second_number => 1)
          @playground.play_stone second_stone
        end

        it "should play stone wherever it can be placed for first number" do
          third_stone = stub(:first_number => 6,
                             :second_number => 2)
          @playground.play_stone third_stone
        end

        it "should play stone wherever it can be placed for second number" do
          third_stone = stub(:first_number => 2,
                             :second_number => 6)
          @playground.play_stone third_stone
        end

        it "should play in right if told" do
          
        end

        it "should play in left if told" do
          
        end

      end
    end
  end
end
