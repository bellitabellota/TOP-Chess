require_relative "player"

class Game
  def initialize
    @player1 = Player.new
    @player2 = Player.new
  end

  def play_game
    create_players
    display_board
  end

  def create_players
    player1.request_name(1)
    player1.request_preferred_set_color
    player2.request_name(2)
    player2.assign_remaining_set_color
  end

  private

  def display_board
    puts
    puts "    a   b   c   d   e   f   g   h  "
    puts "   ------------------------------- "
    puts "8 |   |   |   |   |   |   |   |   | 8"
    puts "   ------------------------------- "
    puts "7 |   |   |   |   |   |   |   |   | 7"
    puts "   ------------------------------- "
    puts "6 |   |   |   |   |   |   |   |   | 6"
    puts "   ------------------------------- "
    puts "5 |   |   |   |   |   |   |   |   | 5"
    puts "   ------------------------------- "
    puts "4 |   |   |   |   |   |   |   |   | 4"
    puts "   ------------------------------- "
    puts "3 |   |   |   |   |   |   |   |   | 3"
    puts "   ------------------------------- "
    puts "2 |   |   |   |   |   |   |   |   | 2"
    puts "   ------------------------------- "
    puts "1 |   |   |   |   |   |   |   |   | 1"
    puts "   ------------------------------- "
    puts "    a   b   c   d   e   f   g   h  "
    puts
  end
end
