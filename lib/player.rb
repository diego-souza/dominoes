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
end
