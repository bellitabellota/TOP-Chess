require_relative "king_vertex"

class KingGraph
  def initialize
    @vertices = create_vertices
  end

  def create_vertices
    array = []
    value_on_x_axis = (0..7)
    value_on_y_axis = (0..7)

    value_on_x_axis.each do |x_value|
      value_on_y_axis.each do |y_value|
        array << KingVertex.new(x_value, y_value)
      end
    end
    array
  end
end
