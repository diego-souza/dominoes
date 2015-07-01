require 'dominoes/playground'
describe Playground do
  it "should have empty area at the beginning" do
    playground = Playground.new
    expect(playground.area).to eq([])
  end
  describe "play" do
    it "should accept first stone if double" do
      stone = double(:double? => true, 
                   :first_number => 6,
                   :second_number => 6)
      playground = Playground.new
      playground.play_stone stone
      expect(playground.area).to eq([6, 6])
    end

    it "should raise error if first stone is not double" do
      stone = double(:double? => false) 
      playground = Playground.new
      expect {playground.play_stone stone, :right}.to raise_error CantPlayStone
      expect(playground.area).to eq([])
    end

    context "when there is a first stone played" do
      before(:each) do
        stone = double(:double? => true, 
                     :first_number => 6,
                     :second_number => 6)
        @playground = Playground.new
        @playground.play_stone stone
      end
      context "last edge" do
        it "should accept if stone matches the edges with first number" do
          stone = double(:matches? => true,
                       :first_number => 6,
                       :second_number => 5)
          @playground.play_stone stone, :last
          expect(@playground.area).to eq([6, 6, 6, 5])
        end
        it "should accept if stone matches the edges with second number" do
          stone = double(:matches? => true,
                       :first_number => 5,
                       :second_number => 6)
          @playground.play_stone stone, :last
          expect(@playground.area).to eq([6, 6, 6, 5])
        end
      end

      context "first edge" do
        it "should accept if stone matches the edges with first number" do
          stone = double(:matches? => true,
                       :first_number => 6,
                       :second_number => 5)
          @playground.play_stone stone, :first
          expect(@playground.area).to eq([5, 6, 6, 6])
        end
        it "should accept if stone matches the edges with second number" do
          stone = double(:matches? => true,
                       :first_number => 5,
                       :second_number => 6)
          @playground.play_stone stone, :first
          expect(@playground.area).to eq([5, 6, 6, 6])
        end
      end

      context "does not match" do
        it "should raise error and not play stone" do
          stone = double(:matches? => false)
          expect { @playground.play_stone stone, :first }.to raise_error CantPlayStone
          expect(@playground.area).to eq([6, 6])
        end
      end
    end
  end
end
