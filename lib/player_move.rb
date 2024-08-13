module PlayerMove
  def make_player_move
    request_player_move
  end

  def request_player_move
    piece_indexes = choose_piece_for_move
    piece_to_move = board[piece_indexes[0]][piece_indexes[1]]

    target_field = choose_target_field(piece_to_move)

    verify_target_field_reachable?(piece_to_move, piece_indexes, target_field)
  end

  def verify_target_field_reachable?(piece_to_move, piece_indexes, target_field)
    target_indexes = convert_to_indexes(target_field)
    piece_class = piece_to_move.class

    if piece_class == Knight
      current_vertex = Knight.graph.find_vertex(piece_indexes)
      current_vertex.reachable_coordinates.include?(target_indexes)
    elsif piece_class == Bishop
      current_vertex = Bishop.graph.find_vertex(piece_indexes)
      current_vertex.reachable_coordinates.include?(target_indexes)
    elsif piece_class == King
      current_vertex = King.graph.find_vertex(piece_indexes)
      current_vertex.reachable_coordinates.include?(target_indexes)
    elsif piece_class == Queen
      current_vertex = Queen.graph.find_vertex(piece_indexes)
      current_vertex.reachable_coordinates.include?(target_indexes)
    elsif piece_class == Rook
      current_vertex = Rook.graph.find_vertex(piece_indexes)
      current_vertex.reachable_coordinates.include?(target_indexes)
    elsif piece_class == Pawn
      reachable_in_graph_of_current_player?(piece_indexes, target_indexes) || diagonal_move_possible?(piece_to_move, piece_indexes, target_indexes)
    else
      false
    end
  end

  def diagonal_move_possible?(piece_to_move, piece_indexes, target_indexes)
    diagonal_indexes = calculate_diagonal_indexes(piece_to_move.start_position[1], piece_indexes)

    if diagonal_indexes.include?(target_indexes)
      current_opponent.set.include?(board[target_indexes[0]] [target_indexes[1]])
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
    current_player == player1 ? current_vertex = Pawn.graph_player1.find_vertex(piece_indexes) : current_vertex = Pawn.graph_player2.find_vertex(piece_indexes)

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
    letters.each_with_index{ |letter, index| number = index if letter == input_letter }
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
