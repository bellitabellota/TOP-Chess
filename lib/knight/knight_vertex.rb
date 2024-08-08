class KnightVertex
  attr_reader :coordinates, :reachable_coordinates

  def initialize(x, y)
    @coordinates = [x, y]
    @reachable_coordinates = filter_for_possible_coordinates
  end

  def filter_for_possible_coordinates
    reachable_coordinates = calculate_moves

    filtered_coordinates = reachable_coordinates.map do |move_array|
      move_array if (0..7).include?(move_array[0]) && (0..7).include?(move_array[1])
    end

    filtered_coordinates.compact
  end

  def calculate_moves
    reachable_coordinates = []
    reachable_coordinates << [coordinates[0] - 1, coordinates[1] + 2]
    reachable_coordinates << [coordinates[0] - 2, coordinates[1] + 1]
    reachable_coordinates << [coordinates[0] - 2, coordinates[1] - 1]
    reachable_coordinates << [coordinates[0] - 1, coordinates[1] - 2]
    reachable_coordinates << [coordinates[0] + 1, coordinates[1] + 2]
    reachable_coordinates << [coordinates[0] + 2, coordinates[1] + 1]
    reachable_coordinates << [coordinates[0] + 2, coordinates[1] - 1]
    reachable_coordinates << [coordinates[0] + 1, coordinates[1] - 2]
  end
end
