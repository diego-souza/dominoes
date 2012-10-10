class Player
  attr_reader :name, :hand
  def initialize params = {}
    @name = params[:name]
    @hand = params[:hand] || []
  end

  def receive_stones stones
    stones = stones.to_a
    @hand += stones
  end

  def give_stones stones
    @hand -= stones.to_a
  end

  def doubles
    @hand.dup.delete_if{|stone| !stone.double?}
  end

  def has_double?
    @hand.each do |stone|
      return true if stone.double?
    end
    false
  end

  def max_double
    doubles = self.doubles
    if doubles.any?
      self.doubles.map{|s| s.first_number}.max
    else
      -1
    end
  end
end
