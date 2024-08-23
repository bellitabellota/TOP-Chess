module Checks
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
        if reachable_in_graph_of_opponent_player?(piece_indexes, field) && pawn_target_field_free?(field) && path_free?(piece, piece_indexes, field)
          opponent_pieces.push(piece)
        end
        opponent_pieces.push(piece) if diagonal_move_possible?(current_player, piece, piece_indexes, field)
      end
    end
    opponent_pieces
  end

  def reachable_in_graph_of_opponent_player?(piece_indexes, target_indexes)
    current_opponent.set_color == "white" ? current_vertex = Pawn.graph_player_white.find_vertex(piece_indexes) : current_vertex = Pawn.graph_player_black.find_vertex(piece_indexes)

    current_vertex.reachable_coordinates.include?(target_indexes)
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
        return true if diagonal_move_possible?(current_player, piece, piece_indexes, coordinates_last_moved_piece)
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
        return true if diagonal_move_possible?(current_opponent, piece, piece_indexes, coordinates_of_opponent_king)
      end
    end
    false
  end
end
