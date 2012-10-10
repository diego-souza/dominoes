class Rules
  def self.player_with_bigest_double players
    player = players.sort_by{|p| p.max_double}.last
    player.max_double == -1 ? nil:player
  end
end
