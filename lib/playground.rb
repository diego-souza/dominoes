require 'exceptions/cant_play_stone'
class Playground
  attr_reader :area
  def initialize
    @area = []
  end

  def play_stone stone, edge = :right
    if @area.empty?
      @area += [stone.first_number, stone.second_number]
    else
      if @area.last == stone.first_number
        @area += [stone.first_number, stone.second_number]
      elsif @area.last == stone.second_number
        @area += [stone.second_number, stone.first_number]
      end
    end
  end
end
