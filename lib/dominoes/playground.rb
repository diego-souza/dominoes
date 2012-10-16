require_relative 'exceptions/cant_play_stone'
class Playground
  attr_reader :area
  def initialize
    @area = []
  end

  def play_stone stone, edge = :last
    if @area.empty? 
      if stone.double?
        @area += [stone.first_number, stone.second_number]
      else
        raise CantPlayStone
      end
    else
      edge_value = self.area.send(edge)
      if stone.matches? edge_value
        other_value = stone.first_number == edge_value ? stone.second_number : stone.first_number
        if edge == :last
          stone_array = [edge_value, other_value]
          @area += stone_array.uniq
        else
          stone_array = [other_value, edge_value]
          @area = stone_array.uniq + @area
        end
      end
    end
  end
end
