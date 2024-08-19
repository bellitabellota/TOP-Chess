require_relative "player"
require_relative "game_preparation"
require_relative "player_move"

class Game
  attr_reader :player1, :player2
  attr_accessor :player1_set, :player2_set, :board, :tboard, :current_player

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Array.new(8) { Array.new(8, nil) }
    @tboard = Array.new(8) { Array.new(8, " ") }
    @current_player = player1
  end

  include GamePreparation
  include PlayerMove

  def play_game
    set_up_game
    display_board

    loop do
      make_player_move
      display_board

      puts "CHECK! #{current_opponent.name} carefully consider your next move." if check?

      switch_current_player
    end
  end

  def check?
    coordinates_of_opponent_king = current_opponent.set[0].coordinates

    reachable_from_current_player_set = false

    current_player.set.each do |piece|
      piece_class = piece.class

      if [Knight, Bishop, King, Queen, Rook].include?(piece_class)
        current_vertex = piece_class.graph.find_vertex(piece.coordinates)
        if current_vertex.reachable_coordinates.include?(coordinates_of_opponent_king) && path_free?(piece, piece.coordinates, coordinates_of_opponent_king)
          return reachable_from_current_player_set = true
        end
      elsif piece_class == Pawn
        piece_indexes = piece.coordinates
        if reachable_in_graph_of_current_player?(piece_indexes, coordinates_of_opponent_king) && path_free?(piece, piece.coordinates, coordinates_of_opponent_king)
          return reachable_from_current_player_set = true
        elsif diagonal_move_possible?(piece, piece_indexes, coordinates_of_opponent_king)
          return reachable_from_current_player_set = true
        end
      end
    end
    reachable_from_current_player_set
  end

  def switch_current_player
    if current_player == player1
      self.current_player = player2
    else
      self.current_player = player1
    end
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
