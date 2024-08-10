class RookVertex
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
      moves_ascending_x_axis(reachable_coordinates, i)
      moves_descending_x_axis(reachable_coordinates, i)
      moves_ascending_y_axis(reachable_coordinates, i)
      moves_descending_y_axis(reachable_coordinates, i)
      i += 1
    end
    reachable_coordinates
  end

  def moves_ascending_x_axis(reachable_coordinates, increment)
    reachable_coordinates << [coordinates[0] + increment, coordinates[1]]
  end

  def moves_descending_x_axis(reachable_coordinates, increment)
    reachable_coordinates << [coordinates[0] - increment, coordinates[1]]
  end

  def moves_ascending_y_axis(reachable_coordinates, increment)
    reachable_coordinates << [coordinates[0], coordinates[1] + increment]
  end

  def moves_descending_y_axis(reachable_coordinates, increment)
    reachable_coordinates << [coordinates[0], coordinates[1] - increment]
  end
end
