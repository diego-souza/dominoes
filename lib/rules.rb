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

end
