require_relative 'exceptions/not_enough_players'
require_relative 'exceptions/player_does_not_own_stone'
require_relative 'exceptions/player_must_buy_or_play'
require_relative 'exceptions/stock_is_empty'
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
      @playground = Playground.new
      @stock = []
      BASIC_STONES.shuffle.each do |stone_values|
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

  def play stone
    raise PlayerDoesNotOwnStone unless @current_player.has_stone? stone
    @playground.play_stone stone
    @current_player.give_stones stone
    @current_player = Rules.next_player @players, @current_player
  end

  def pass
    raise PlayerMustBuyOrPlay unless @stock.empty?
    @current_player = Rules.next_player @players, @current_player
  end

  def buy
    raise StockIsEmpty if @stock.empty?
    @current_player.receive_stones @stock.first
  end
end
