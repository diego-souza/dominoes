require 'exceptions/not_enough_players'
require_relative 'player'
require_relative 'stone'
require_relative 'playground'
require_relative 'rules'

class Game
  attr_reader :players, :current_player, :stock, :playground
  BASIC_STONES = (0..6).to_a.repeated_combination(2).to_a

  def initialize params = {}
    while @current_player == nil
      @players = []
      @stock = []
      BASIC_STONES.each do |stone_values|
        @stock << Stone.new(stone_values.first, stone_values.last)
      end
      params[:players].each do |player_name|
        player = Player.new(:name => player_name)
        player.receive_stones @stock.pop(7)
        @players << player
      end
      raise NotEnoughPlayers unless @players.size >= 2
      @current_player = Rules.player_with_bigest_double @players
    end
  end
end
