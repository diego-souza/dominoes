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
      stone.double?.should be_true
    end

    it "should be false if both numbers are not the same" do
      stone = Stone.new 1, 2
      stone.double?.should be_false
    end
  end

  describe "matches?" do
    subject { Stone.new 1, 2 }

    it "should match something equal its numbers" do
      subject.matches?(1).should be_true
      subject.matches?(2).should be_true
    end

    it "should not match something not equal its numbers" do
      subject.matches?(3).should be_false
    end
  end
end
