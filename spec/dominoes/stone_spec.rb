require 'dominoes/stone'
describe Stone do
  it "should have two numbers" do
    stone = Stone.new 1, 2
    stone.first_number == 1
    stone.second_number == 2
  end

  describe "double?" do
    it "should be true if both numbers are the same" do
      stone = Stone.new 1, 1
      expect(stone.double?).to be_truthy
    end

    it "should be false if both numbers are not the same" do
      stone = Stone.new 1, 2
      expect(stone.double?).to be_falsey
    end
  end

  describe "matches?" do
    subject { Stone.new 1, 2 }

    it "should match something equal its numbers" do
      expect(subject.matches?(1)).to be_truthy
      expect(subject.matches?(2)).to be_truthy
    end

    it "should not match something not equal its numbers" do
      expect(subject.matches?(3)).to be_falsey
    end
  end
end
