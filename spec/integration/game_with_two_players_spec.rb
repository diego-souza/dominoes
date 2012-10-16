require 'dominoes'
describe "Game with two players" do
  before(:each) do
    @players = ["Diego", "Hugo"]
    @game = Game.new :players => @players
  end

  it "its players should have the names indicated" do
    @game.players.map{|p| p.name}.should =~ @players 
  end

  it "current player should play a stone" do
    stone = @game.current_player.doubles.last
    @game.play stone
  end
end
