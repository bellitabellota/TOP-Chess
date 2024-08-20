module PawnPromotion
  def check_and_apply_pawn_promotion(player_move)
    moved_piece = board[player_move[1][0]][player_move[1][1]]

    return unless moved_piece.is_a?(Pawn)

    return unless advanced_to_eighth_rank?(moved_piece, player_move)

    pawn_promotion(moved_piece)
    display_board
  end

  def advanced_to_eighth_rank?(moved_piece, player_move)
    return true if moved_piece.start_position[1] == 1 && player_move[1][1] == 7
    return true if moved_piece.start_position[1] == 6 && (player_move[1][1]).zero?

    false
  end

  def pawn_promotion(pawn)
    puts "#{current_player.name} press 'q' to exchange your Pawn for a Queen, 'r' for a Rook, 'b' for a Bishop or 'k' for a Knight:"
    player_choice = request_player_choice
    replace_pawn_with_player_choice(player_choice, pawn)
  end

  def replace_pawn_with_player_choice(player_choice, pawn)
    token_index = check_token_index
    chosen_piece = create_chosen_piece(player_choice, token_index)
    chosen_piece.coordinates = pawn.coordinates

    current_player.set.delete(pawn)

    current_player.set.insert(2, chosen_piece)

    board[chosen_piece.coordinates[0]][chosen_piece.coordinates[1]] = chosen_piece
    tboard[chosen_piece.coordinates[0]][chosen_piece.coordinates[1]] = chosen_piece.token
  end

  def check_token_index
    current_player.set_color == "white" ? 0 : 1
  end

  def create_chosen_piece(player_choice, token_index)
    case player_choice
    when "q"
      Queen.new(token_index)
    when "r"
      Rook.new(token_index)
    when "b"
      Bishop.new(token_index)
    when "k"
      Knight.new(token_index)
    end
  end

  def request_player_choice
    loop do
      input = gets.chomp
      return input if ["q", "r", "b", "k"].include?(input.downcase)
    end
  end
end
