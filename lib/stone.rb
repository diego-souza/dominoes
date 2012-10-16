class Stone
  attr_reader :first_number, :second_number
  def initialize first_number, second_number
    @first_number = first_number
    @second_number = second_number
  end

  def double?
    @first_number == @second_number
  end

  def matches? number
    @first_number == number || @second_number == number
  end
end
