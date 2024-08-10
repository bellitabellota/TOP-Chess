require_relative "player"

class Game
  attr_reader :player1, :player2
  attr_accessor :player1_set, :player2_set, :board, :tboard

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Array.new(8) { Array.new(8, nil) }
    @tboard = Array.new(8) { Array.new(8, " ") }
  end

  def play_game
    create_players
    create_set(player1)
    create_set(player2)
    p player1.set
    p player2.set

    place_set_on_board
    place_set_tokens_on_tboard

    display_board
  end

  def place_set_tokens_on_tboard
    board.each_with_index do |array, index|
      array.each_with_index do |value, inner_index|
        if !value.nil?
          tboard[index][inner_index] = value.token
        end
      end
    end
  end

  def place_set_on_board
    player1.set.each { |piece| board[piece.coordinates[0]][piece.coordinates[1]] = piece }
    player2.set.each { |piece| board[piece.coordinates[0]][piece.coordinates[1]] = piece }
  end

  def create_set(player)
    if player.set_color == "white"
      player.assign_pieces(0)
    else
      player.assign_pieces(1)
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
    puts "8 | #{tboard[0][7]} | #{tboard[1][7]} | #{tboard[2][7]} | #{tboard[3][7]} | #{tboard[4][7]} | #{tboard[5][7]} | #{tboard[6][7]} | #{tboard[7][7]} | 8"
    puts "   ------------------------------- "
    puts "7 | #{tboard[0][6]} | #{tboard[1][6]} | #{tboard[2][6]} | #{tboard[3][6]} | #{tboard[4][6]} | #{tboard[5][6]} | #{tboard[6][6]} | #{tboard[7][6]} | 7"
    puts "   ------------------------------- "
    puts "6 | #{tboard[0][5]} | #{tboard[1][5]} | #{tboard[2][5]} | #{tboard[3][5]} | #{tboard[4][5]} | #{tboard[5][5]} | #{tboard[6][5]} | #{tboard[7][5]} | 6"
    puts "   ------------------------------- "
    puts "5 | #{tboard[0][4]} | #{tboard[1][4]} | #{tboard[2][4]} | #{tboard[3][4]} | #{tboard[4][4]} | #{tboard[5][4]} | #{tboard[6][4]} | #{tboard[7][4]} | 5"
    puts "   ------------------------------- "
    puts "4 | #{tboard[0][3]} | #{tboard[1][3]} | #{tboard[2][3]} | #{tboard[3][3]} | #{tboard[4][3]} | #{tboard[5][3]} | #{tboard[6][3]} | #{tboard[7][3]} | 4"
    puts "   ------------------------------- "
    puts "3 | #{tboard[0][2]} | #{tboard[1][2]} | #{tboard[2][2]} | #{tboard[3][2]} | #{tboard[4][2]} | #{tboard[5][2]} | #{tboard[6][2]} | #{tboard[7][2]} | 3"
    puts "   ------------------------------- "
    puts "2 | #{tboard[0][1]} | #{tboard[1][1]} | #{tboard[2][1]} | #{tboard[3][1]} | #{tboard[4][1]} | #{tboard[5][1]} | #{tboard[6][1]} | #{tboard[7][1]} | 2"
    puts "   ------------------------------- "
    puts "1 | #{tboard[0][0]} | #{tboard[1][0]} | #{tboard[2][0]} | #{tboard[3][0]} | #{tboard[4][0]} | #{tboard[5][0]} | #{tboard[6][0]} | #{tboard[7][0]} | 1"
    puts "   ------------------------------- "
    puts "    a   b   c   d   e   f   g   h  "
    puts
  end
end
