module KinginCheck
  def reject_move(captured_opponent_piece, player_move, index_captured_opponent_piece)
    puts "Invalid move. This is move leaves your king in check. Enter another move:"
    undo_last_move(captured_opponent_piece, player_move, index_captured_opponent_piece)
    make_player_move
  end

  def undo_last_move(captured_opponent_piece, player_move, index_captured_opponent_piece)
    unless captured_opponent_piece.nil?
      add_captured_opponent_piece_back_to_set(captured_opponent_piece, index_captured_opponent_piece)
    end

    undo_update_board(player_move, captured_opponent_piece)
    update_tokens_on_tboard
    undo_update_coordinates_of_moved_piece(player_move)
  end

  def undo_update_coordinates_of_moved_piece(player_move)
    board[player_move[0][0]][player_move[0][1]].coordinates = [player_move[0][0], player_move[0][1]]
  end

  def undo_update_board(player_move, captured_opponent_piece)
    board[player_move[0][0]][player_move[0][1]] = board[player_move[1][0]][player_move[1][1]]
    board[player_move[1][0]][player_move[1][1]] = captured_opponent_piece
  end

  def add_captured_opponent_piece_back_to_set(captured_opponent_piece, index_captured_opponent_piece)
    current_opponent.set.insert(index_captured_opponent_piece, captured_opponent_piece)
  end

  def leaves_king_in_check?(player, opponent)
    coordinates_king = player.set[0].coordinates
    reachable_from_opponent_set = false

    opponent.set.each do |piece|
      piece_class = piece.class

      if [Knight, Bishop, King, Queen, Rook].include?(piece_class)
        current_vertex = piece_class.graph.find_vertex(piece.coordinates)
        if current_vertex.reachable_coordinates.include?(coordinates_king) && path_free?(piece, piece.coordinates, coordinates_king)
          return reachable_from_opponent_set = true
        end
      elsif piece_class == Pawn
        piece_indexes = piece.coordinates

        if diagonal_move_possible?(player, piece, piece_indexes, coordinates_king)
          return reachable_from_opponent_set = true
        end
      end
    end
    reachable_from_opponent_set
  end
end
