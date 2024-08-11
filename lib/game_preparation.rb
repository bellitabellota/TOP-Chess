module GamePreparation
  def set_up_game
    create_players

    2.times do
      create_set(current_player)
      switch_current_player
    end

    place_set_on_board
    place_set_tokens_on_tboard
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
      player.assign_pieces(0, player)
    else
      player.assign_pieces(1, player)
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
