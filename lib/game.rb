class Game
  def initialize
    
  end

  def play_game
    display_board
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
