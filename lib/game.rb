require_relative "player"
require_relative "piece_set"

class Game
  attr_reader :player1, :player2
  attr_accessor :player1_set, :player2_set, :board

  def initialize
    @player1 = Player.new
    @player1_set = nil
    @player2 = Player.new
    @player1_set = nil
    @board = Array.new(8) { Array.new(8, " ") }
  end

  def play_game
    create_players

    self.player1_set = create_set(player1)
    self.player2_set = create_set(player2)

    place_set_on_board

    display_board
  end

  def place_set_on_board
    board[player1_set.knight1.coordinates[0]][player1_set.knight1.coordinates[1]] = player1_set.knight1
    board[player1_set.knight2.coordinates[0]][player1_set.knight2.coordinates[1]] = player1_set.knight2
    board[player2_set.knight1.coordinates[0]][player2_set.knight1.coordinates[1]] = player2_set.knight1
    board[player2_set.knight2.coordinates[0]][player2_set.knight2.coordinates[1]] = player2_set.knight2
  end

  def create_set(player)
    if player.set_color == "white"
      PieceSet.new(0)
    else
      PieceSet.new(1)
    end
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
    puts "8 | #{board[0][7]} | #{board[1][7]} | #{board[2][7]} | #{board[3][7]} | #{board[4][7]} | #{board[5][7]} | #{board[6][7]} | #{board[7][7]} | 8"
    puts "   ------------------------------- "
    puts "7 | #{board[0][6]} | #{board[1][6]} | #{board[2][6]} | #{board[3][6]} | #{board[4][6]} | #{board[5][6]} | #{board[6][6]} | #{board[7][6]} | 7"
    puts "   ------------------------------- "
    puts "6 | #{board[0][5]} | #{board[1][5]} | #{board[2][5]} | #{board[3][5]} | #{board[4][5]} | #{board[5][5]} | #{board[6][5]} | #{board[7][5]} | 6"
    puts "   ------------------------------- "
    puts "5 | #{board[0][4]} | #{board[1][4]} | #{board[2][4]} | #{board[3][4]} | #{board[4][4]} | #{board[5][4]} | #{board[6][4]} | #{board[7][4]} | 5"
    puts "   ------------------------------- "
    puts "4 | #{board[0][3]} | #{board[1][3]} | #{board[2][3]} | #{board[3][3]} | #{board[4][3]} | #{board[5][3]} | #{board[6][3]} | #{board[7][3]} | 4"
    puts "   ------------------------------- "
    puts "3 | #{board[0][2]} | #{board[1][2]} | #{board[2][2]} | #{board[3][2]} | #{board[4][2]} | #{board[5][2]} | #{board[6][2]} | #{board[7][2]} | 3"
    puts "   ------------------------------- "
    puts "2 | #{board[0][1]} | #{board[1][1]} | #{board[2][1]} | #{board[3][1]} | #{board[4][1]} | #{board[5][1]} | #{board[6][1]} | #{board[7][1]} | 2"
    puts "   ------------------------------- "
    puts "1 | #{board[0][0]} | #{board[1][0]} | #{board[2][0]} | #{board[3][0]} | #{board[4][0]} | #{board[5][0]} | #{board[6][0]} | #{board[7][0]} | 1"
    puts "   ------------------------------- "
    puts "    a   b   c   d   e   f   g   h  "
    puts
  end
end
