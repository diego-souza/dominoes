require 'dominoes/playground'
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

    it "should raise error if first stone is not double" do
      stone = stub(:double? => false) 
      playground = Playground.new
      lambda {playground.play_stone stone, :right}.should raise_error CantPlayStone
      playground.area.should == []
    end

    context "when there is a first stone played" do
      before(:each) do
        stone = stub(:double? => true, 
                     :first_number => 6,
                     :second_number => 6)
        @playground = Playground.new
        @playground.play_stone stone
      end
      context "last edge" do
        it "should accept if stone matches the edges with first number" do
          stone = stub(:matches? => true,
                       :first_number => 6,
                       :second_number => 5)
          @playground.play_stone stone, :last
          @playground.area.should == [6, 6, 6, 5]
        end
        it "should accept if stone matches the edges with second number" do
          stone = stub(:matches? => true,
                       :first_number => 5,
                       :second_number => 6)
          @playground.play_stone stone, :last
          @playground.area.should == [6, 6, 6, 5]
        end
      end

      context "first edge" do
        it "should accept if stone matches the edges with first number" do
          stone = stub(:matches? => true,
                       :first_number => 6,
                       :second_number => 5)
          @playground.play_stone stone, :first
          @playground.area.should == [5, 6, 6, 6]
        end
        it "should accept if stone matches the edges with second number" do
          stone = stub(:matches? => true,
                       :first_number => 5,
                       :second_number => 6)
          @playground.play_stone stone, :first
          @playground.area.should == [5, 6, 6, 6]
        end
      end

      context "does not match" do
        it "should raise error and not play stone" do
          stone = stub(:matches? => false)
          lambda { @playground.play_stone stone, :first }.should raise_error CantPlayStone
          @playground.area.should == [6, 6]
        end
      end
    end
  end
end
