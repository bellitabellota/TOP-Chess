require_relative "player"
require_relative "game_preparation"
require_relative "player_move"

class Game
  attr_reader :player1, :player2
  attr_accessor :player1_set, :player2_set, :board, :tboard, :current_player, :piece_moved_during_current_turn

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Array.new(8) { Array.new(8, nil) }
    @tboard = Array.new(8) { Array.new(8, " ") }
    @current_player = player1
    @piece_moved_during_current_turn = nil
  end

  include GamePreparation
  include PlayerMove

  def play_game
    set_up_game
    display_board

    loop do
      make_player_move
      display_board

      return puts "CHECKMATE!!! The game is over. #{current_opponent.name} lost." if checkmate?

      puts "CHECK! #{current_opponent.name} carefully consider your next move." if check?

      switch_current_player
    end
  end

  def checkmate?
    if check?
      all_possible_moves_lead_to_check? && !threatening_piece_capturable? && !path_blockable?
    else
      false
    end
  end

  def path_blockable?
    piece_class = piece_moved_during_current_turn.class

    if [Bishop, Queen, Rook].include?(piece_class)
      all_opponent_pieces_with_legal_moves = []
      fields_on_path_to_king = calculate_fields_on_move(piece_moved_during_current_turn.coordinates, current_opponent.set[0].coordinates)

      fields_on_path_to_king.each do |field|
        opponent_pieces = reachable_by_opponent_piece(field)

        opponent_pieces_with_legal_moves = keep_pieces_with_legal_move(opponent_pieces, field)

        all_opponent_pieces_with_legal_moves.push(opponent_pieces_with_legal_moves)
      end

      !all_opponent_pieces_with_legal_moves.flatten.empty?
    else
      false
    end
  end

  def keep_pieces_with_legal_move(opponent_pieces, field)
    opponent_pieces_with_legal_moves = []

    opponent_pieces.each do |opponent_piece|
      player_move = [opponent_piece.coordinates, field]

      piece_on_field = board[player_move[1][0]][player_move[1][1]]

      update_board(player_move)
      update_coordinates_of_moved_piece(player_move)

      unless leaves_king_in_check?(current_opponent, current_player)
        opponent_pieces_with_legal_moves.push(opponent_piece)
      end

      undo_update_board(player_move, piece_on_field)
      undo_update_coordinates_of_moved_piece(player_move)
    end
    opponent_pieces_with_legal_moves
  end

  def reachable_by_opponent_piece(field)
    opponent_pieces = []
    current_opponent.set.each do |piece|
      piece_class = piece.class

      if [Knight, Bishop, King, Queen, Rook].include?(piece_class)
        current_vertex = piece_class.graph.find_vertex(piece.coordinates)
        if current_vertex.reachable_coordinates.include?(field) && path_free?(piece, piece.coordinates, field) && target_field_not_containing_own_piece?(field, current_opponent)
          opponent_pieces.push(piece)
        end
      elsif piece_class == Pawn
        piece_indexes = piece.coordinates
        opponent_pieces.push(piece) if diagonal_move_possible?(current_player, piece, piece_indexes, field)
      end
    end
    opponent_pieces
  end

  def threatening_piece_capturable?
    capturable_by_opponent_players_pieces?(piece_moved_during_current_turn.coordinates)
  end

  def capturable_by_opponent_players_pieces?(coordinates_last_moved_piece)
    current_opponent.set.each do |piece|
      piece_class = piece.class

      if [Knight, Bishop, King, Queen, Rook].include?(piece_class)
        current_vertex = piece_class.graph.find_vertex(piece.coordinates)
        if current_vertex.reachable_coordinates.include?(coordinates_last_moved_piece) && path_free?(piece, piece.coordinates, coordinates_last_moved_piece)
          return true
        end
      elsif piece_class == Pawn
        piece_indexes = piece.coordinates
        if diagonal_move_possible?(current_player, piece, piece_indexes, coordinates_last_moved_piece)
          return true
        end
      end
    end
    false
  end

  def all_possible_moves_lead_to_check?
    current_vertex = King.graph.find_vertex(current_opponent.set[0].coordinates)
    coordinates_next_moves_opponent_king = current_vertex.reachable_coordinates
    possible_coordinates_next_moves_opponent_king = coordinates_next_moves_opponent_king.select do |target_indexes|
      target_field_not_containing_opponent_piece?(target_indexes)
    end

    possible_coordinates_next_moves_opponent_king.each do |next_coordinate_opponent_king|
      return false unless capturable_by_current_players_pieces?(next_coordinate_opponent_king)
    end

    true
  end

  def target_field_not_containing_opponent_piece?(target_indexes)
    return false if current_opponent.set.include?(board[target_indexes[0]] [target_indexes[1]])

    true
  end

  def check?
    coordinates_of_opponent_king = current_opponent.set[0].coordinates

    capturable_by_current_players_pieces?(coordinates_of_opponent_king)
  end

  def capturable_by_current_players_pieces?(coordinates_of_opponent_king)
    current_player.set.each do |piece|
      piece_class = piece.class

      if [Knight, Bishop, King, Queen, Rook].include?(piece_class)
        current_vertex = piece_class.graph.find_vertex(piece.coordinates)
        if current_vertex.reachable_coordinates.include?(coordinates_of_opponent_king) && path_free?(piece, piece.coordinates, coordinates_of_opponent_king)
          return true
        end
      elsif piece_class == Pawn
        piece_indexes = piece.coordinates
        if diagonal_move_possible?(current_opponent, piece, piece_indexes, coordinates_of_opponent_king)
          return true
        end
      end
    end
    false
  end

  def switch_current_player
    if current_player == player1
      self.current_player = player2
    else
      self.current_player = player1
    end
  end

  private

  def update_tokens_on_tboard
    reset_tboard unless tboard_empty?

    board.each_with_index do |array, index|
      array.each_with_index do |value, inner_index|
        tboard[index][inner_index] = value.token unless value.nil?
      end
    end
  end

  def tboard_empty?
    tboard.each do |inner_array|
      return false unless inner_array.all? { |value| value == " " }
    end
    true
  end

  def reset_tboard
    self.tboard = Array.new(8) { Array.new(8, " ") }
  end

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
