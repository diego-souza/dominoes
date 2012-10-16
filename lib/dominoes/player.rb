class Player
  attr_reader :name, :hand
  def initialize params = {}
    @name = params[:name]
    @hand = params[:hand] || []
  end

  def receive_stones stones
    stones = Array(stones)
    @hand += stones
  end

  def give_stones stones
    @hand -= Array(stones)
  end

  def doubles
    @hand.dup.delete_if{|stone| !stone.double?}
  end

  def has_double?
    self.doubles.any?
  end

  def max_double
    self.doubles.map{|s| s.first_number}.max || -1
  end

  def has_stone? stone
    self.hand.include? stone
  end
end
