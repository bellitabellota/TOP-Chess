class PawnVertex
  attr_reader :coordinates, :reachable_coordinates

  def initialize(x, y, player)
    @coordinates = [x, y]
    @reachable_coordinates = filter_for_possible_coordinates(player)
  end

  def filter_for_possible_coordinates(player)
    reachable_coordinates = calculate_moves(player)

    filtered_coordinates = reachable_coordinates.map do |move_array|
      move_array if (0..7).include?(move_array[0]) && (0..7).include?(move_array[1])
    end

    filtered_coordinates.compact
  end

  def calculate_moves(player)
    reachable_coordinates = []

    if player.set[-1].coordinates[1] == 6
      calculate_moves_upper_player(reachable_coordinates)
    elsif player.set[-1].coordinates[1] == 1
      calculate_moves_lower_player(reachable_coordinates)
    end
    reachable_coordinates
  end

  def calculate_moves_lower_player(reachable_coordinates)
    reachable_coordinates << [coordinates[0], coordinates[1] + 2] if coordinates[1] == 1
    reachable_coordinates << [coordinates[0], coordinates[1] + 1]
  end

  def calculate_moves_upper_player(reachable_coordinates)
    reachable_coordinates << [coordinates[0], coordinates[1] - 2] if coordinates[1] == 6
    reachable_coordinates << [coordinates[0], coordinates[1] - 1]
  end
end
