module GamePreparation
  def set_up_game
    create_players
    create_set

    place_set_on_board
    place_set_tokens_on_tboard

    if current_player.set_color == "black"
      switch_current_player
    end
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

  def create_set
    if player1.set_color == "white"
      player2.assign_pieces(1, player2)
      player1.assign_pieces(0, player1)
    else
      player1.assign_pieces(1, player1)
      player2.assign_pieces(0, player2)
    end
  end

  def create_players
    current_player.request_name(1)
    current_player.request_preferred_set_color
    switch_current_player

    current_player.request_name(2)
    current_player.assign_remaining_set_color
    switch_current_player
  end
end
