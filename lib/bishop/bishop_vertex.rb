class BishopVertex
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
    i = 1

    7.times do
      right_ascending(reachable_coordinates, i)
      left__descending(reachable_coordinates, i)
      left_ascending(reachable_coordinates, i)
      right_descending(reachable_coordinates, i)
      i += 1
    end
    reachable_coordinates
  end

  def right_ascending(reachable_coordinates, increment)
    reachable_coordinates << [coordinates[0] + increment, coordinates[1] + increment]
  end

  def left__descending(reachable_coordinates, increment)
    reachable_coordinates << [coordinates[0] - increment, coordinates[1] - increment]
  end

  def left_ascending(reachable_coordinates, increment)
    reachable_coordinates << [coordinates[0] - increment, coordinates[1] + increment]
  end

  def right_descending(reachable_coordinates, increment)
    reachable_coordinates << [coordinates[0] + increment, coordinates[1] - increment]
  end
end
