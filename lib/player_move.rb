module PlayerMove
  def make_player_move
    player_move = request_player_move
    captured_opponent_piece = update_opponent_set_when_capture(player_move)
    update_board(player_move)
    update_tboard(player_move)
    update_coordinates_of_moved_piece(player_move)

    if leaves_own_king_in_check?
      puts "Invalid move. This is move leaves your king in check. Enter another move:"
      undo_last_move(captured_opponent_piece, player_move)
      make_player_move
    end

    if board[player_move[1][0]][player_move[1][1]].is_a?(Pawn)
      pawn = board[player_move[1][0]][player_move[1][1]]
      if pawn.start_position[1] == 1 && player_move[1][1] == 7
        pawn_promotion(pawn)
      elsif pawn.start_position[1] == 6 && player_move[1][1] == 0
        pawn_promotion(pawn)
      else
        return
      end
      display_board
    end
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

  def undo_last_move(captured_opponent_piece, player_move)
    add_captured_opponent_piece_back_to_set(captured_opponent_piece)
    undo_update_board(player_move, captured_opponent_piece)
    undo_update_coordinates_of_moved_piece(player_move)
    undo_update_tboard(player_move, captured_opponent_piece)
  end

  def undo_update_coordinates_of_moved_piece(player_move)
    board[player_move[0][0]][player_move[0][1]].coordinates = [player_move[0][0], player_move[0][1]]
  end

  def undo_update_board(player_move, captured_opponent_piece)
    board[player_move[0][0]][player_move[0][1]] = board[player_move[1][0]][player_move[1][1]]
    board[player_move[1][0]][player_move[1][1]] = captured_opponent_piece
  end

  def undo_update_tboard(player_move, captured_opponent_piece)
    tboard[player_move[0][0]][player_move[0][1]] = tboard[player_move[1][0]][player_move[1][1]]
    if captured_opponent_piece.nil?
      tboard[player_move[1][0]][player_move[1][1]] = " "
    else
      tboard[player_move[1][0]][player_move[1][1]] = captured_opponent_piece.token
    end
  end

  def add_captured_opponent_piece_back_to_set(captured_opponent_piece)
    current_opponent.set.insert(1, captured_opponent_piece)
  end

  def update_coordinates_of_moved_piece(player_move)
    board[player_move[1][0]][player_move[1][1]].coordinates = [player_move[1][0], player_move[1][1]]
  end

  def leaves_own_king_in_check?
    coordinates_king = current_player.set[0].coordinates
    reachable_from_current_opponent_set = false

    current_opponent.set.each do |piece|
      piece_class = piece.class

      if [Knight, Bishop, King, Queen, Rook].include?(piece_class)
        current_vertex = piece_class.graph.find_vertex(piece.coordinates)
        if current_vertex.reachable_coordinates.include?(coordinates_king) && path_free?(piece, piece.coordinates, coordinates_king)
          return reachable_from_current_opponent_set = true
        end
      elsif piece_class == Pawn
        piece_indexes = piece.coordinates
        if reachable_in_graph_of_opponent_player?(coordinates_king, piece_indexes) && path_free?(piece, piece.coordinates, coordinates_king)
          return reachable_from_current_opponent_set = true
        elsif diagonal_move_possible?(current_player, piece, piece_indexes, coordinates_king)
          return reachable_from_current_opponent_set = true
        end
      end
    end
    reachable_from_current_opponent_set
  end

  def reachable_in_graph_of_opponent_player?(coordinates_king, piece_indexes)
    current_opponent.set_color == "white" ? current_vertex = Pawn.graph_player_white.find_vertex(piece_indexes) : current_vertex = Pawn.graph_player_black.find_vertex(piece_indexes)

    current_vertex.reachable_coordinates.include?(coordinates_king)
  end

  def update_board(player_move)
    board[player_move[1][0]][player_move[1][1]] = board[player_move[0][0]][player_move[0][1]]
    board[player_move[0][0]][player_move[0][1]] = nil
  end

  def update_tboard(player_move)
    tboard[player_move[1][0]][player_move[1][1]] = tboard[player_move[0][0]][player_move[0][1]]
    tboard[player_move[0][0]][player_move[0][1]] = " "
  end

  def update_opponent_set_when_capture(player_move)
    if current_opponent.set.include?(board[player_move[1][0]][player_move[1][1]])
      current_opponent.set.delete(board[player_move[1][0]][player_move[1][1]])
    end
    board[player_move[1][0]][player_move[1][1]]
  end

  def request_player_move
    loop do
      piece_indexes = choose_piece_for_move
      piece_to_move = board[piece_indexes[0]][piece_indexes[1]]

      target_field = choose_target_field(piece_to_move)
      target_indexes = convert_to_indexes(target_field)

      return [piece_indexes, target_indexes] if move_possible?(piece_to_move, piece_indexes, target_indexes)

      puts "This is not a valid move. Let's try again."
      puts
    end
  end

  def move_possible?(piece_to_move, piece_indexes, target_indexes)
    return false if piece_indexes == target_indexes
    return false unless verify_target_field_reachable?(piece_to_move, piece_indexes, target_indexes)
    return false unless target_field_not_containing_own_piece?(target_indexes)
    return false unless path_free?(piece_to_move, piece_indexes, target_indexes)

    true
  end

  def path_free?(piece_to_move, piece_indexes, target_indexes)
    return true if piece_to_move.is_a?(Knight)

    fields_on_move = calculate_fields_on_move(piece_indexes, target_indexes)

    fields_on_move.each { |field_on_move| return false unless board[field_on_move[0]][field_on_move[1]].nil? }
    true
  end

  def calculate_fields_on_move(piece_indexes, target_indexes)
    if piece_indexes[0] == target_indexes[0]
      vertical_path(piece_indexes, target_indexes)
    elsif piece_indexes[1] == target_indexes[1]
      horizontal_path(piece_indexes, target_indexes)
    else
      diagonal_path(piece_indexes, target_indexes)
    end
  end

  def diagonal_path(piece_indexes, target_indexes)
    start_indexes = piece_indexes.map { |num| num }
    y_summand = start_indexes[1] > target_indexes[1] ? -1 : 1
    x_summand = start_indexes[0] > target_indexes[0] ? -1 : 1
    array = []

    until start_indexes[1] == target_indexes[1] - y_summand
      array.push([start_indexes[0] + x_summand, start_indexes[1] + y_summand])
      start_indexes[1] += y_summand
      start_indexes[0] += x_summand
    end
    array
  end

  def vertical_path(piece_indexes, target_indexes)
    start_indexes = piece_indexes.map { |num| num }
    summand = start_indexes[1] > target_indexes[1] ? -1 : 1
    array = []

    until start_indexes[1] == target_indexes[1] - summand
      array.push([start_indexes[0], start_indexes[1] + summand])
      start_indexes[1] += summand
    end
    array
  end

  def horizontal_path(piece_indexes, target_indexes)
    start_indexes = piece_indexes.map { |num| num }
    summand = start_indexes[0] > target_indexes[0] ? -1 : 1
    array = []

    until start_indexes[0] == target_indexes[0] - summand
      array.push([start_indexes[0] + summand, start_indexes[1]])
      start_indexes[0] += summand
    end
    array
  end

  def target_field_not_containing_own_piece?(target_indexes)
    return false if current_player.set.include?(board[target_indexes[0]] [target_indexes[1]])

    true
  end

  def verify_target_field_reachable?(piece_to_move, piece_indexes, target_indexes)
    piece_class = piece_to_move.class

    if [Knight, Bishop, King, Queen, Rook].include?(piece_class)
      current_vertex = piece_class.graph.find_vertex(piece_indexes)
      current_vertex.reachable_coordinates.include?(target_indexes)
    elsif piece_class == Pawn
      reachable_in_graph_of_current_player?(piece_indexes, target_indexes) || diagonal_move_possible?(current_opponent, piece_to_move, piece_indexes, target_indexes)
    else
      false
    end
  end

  def diagonal_move_possible?(player, piece_to_move, piece_indexes, target_indexes)
    diagonal_indexes = calculate_diagonal_indexes(piece_to_move.start_position[1], piece_indexes)
    if diagonal_indexes.include?(target_indexes)
      player.set.include?(board[target_indexes[0]] [target_indexes[1]])
    end
  end

  def calculate_diagonal_indexes(y_value, piece_indexes)
    if y_value == 6
      diagonal_left = [piece_indexes[0] - 1, piece_indexes[1] - 1]
      diagonal_right = [piece_indexes[0] + 1, piece_indexes[1] - 1]

      [diagonal_left, diagonal_right]
    elsif y_value == 1
      diagonal_left = [piece_indexes[0] - 1, piece_indexes[1] + 1]
      diagonal_right = [piece_indexes[0] + 1, piece_indexes[1] + 1]

      [diagonal_left, diagonal_right]
    end
  end

  def current_opponent
    if current_player == player1
      player2
    else
      player1
    end
  end

  def reachable_in_graph_of_current_player?(piece_indexes, target_indexes)
    current_player.set_color == "white" ? current_vertex = Pawn.graph_player_white.find_vertex(piece_indexes) : current_vertex = Pawn.graph_player_black.find_vertex(piece_indexes)

    current_vertex.reachable_coordinates.include?(target_indexes)
  end

  def choose_target_field(piece_to_move)
    puts
    puts "#{current_player.name} where do you want to place your #{piece_to_move.class}? Please enter the coordinates:"
    request_coordinates
  end

  def choose_piece_for_move
    loop do
      puts "#{current_player.name} enter the coordinates of the piece you want to move (e.g. b2):"
      piece_position = request_coordinates

      board_indexes = convert_to_indexes(piece_position)

      return board_indexes if field_contains_piece_of_player?(board_indexes)

      puts "The field you entered does not contain a piece of your set."
      puts
    end
  end

  def field_contains_piece_of_player?(board_indexes)
    current_player.set.include?(board[board_indexes[0]][board_indexes[1]])
  end

  def convert_to_indexes(piece_position)
    array = piece_position.split("")

    array[0] = convert_letter(array[0].downcase)
    array[1] = array[1].to_i - 1

    array
  end

  def convert_letter(input_letter)
    letters = ("a".."h").to_a
    number = nil
    letters.each_with_index { |letter, index| number = index if letter == input_letter }
    number
  end

  def request_coordinates
    loop do
      input = gets.chomp
      return input if verify_input(input)

      puts "Invalid input. Try again:"
    end
  end

  def verify_input(input)
    return false if input.length != 2

    input = input.split("")

    return false unless verify_first_character(input[0]) && verify_second_character(input[1])

    true
  end

  def verify_second_character(second_character)
    ("1".."8").include?(second_character)
  end

  def verify_first_character(first_character)
    ("a".."h").include?(first_character.downcase)
  end
end
