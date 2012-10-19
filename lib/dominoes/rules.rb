class Rules
  def self.player_with_bigest_double players
    player = players.sort_by{|p| p.max_double}.last
    player.max_double == -1 ? nil:player
  end

  def self.winner players
    players.dup.delete_if{|p| p.hand.any?}.first
  end

  def self.winner? players
    Rules.winner(players).any?
  end

  def self.next_player players, current_player
    players[(players.index(current_player)+1) % players.size]
  end

  def self.game_over? players, stock, edges
    return true if self.winner?(players)
    return false if stock.any?
    return true if self.stuck? players, edges
    false
  end

  def self.stuck? players, edges
    players.each do |player|
      return false if player.has_matching_stone? edges.first
      return false if player.has_matching_stone? edges.last
    end
    true
  end
end
