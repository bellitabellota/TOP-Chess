require_relative "bishop_vertex"

class BishopGraph
  attr_accessor :vertices

  def initialize
    @vertices = create_vertices
  end

  def create_vertices
    array = []
    value_on_x_axis = (0..7)
    value_on_y_axis = (0..7)

    value_on_x_axis.each do |x_value|
      value_on_y_axis.each do |y_value|
        array << BishopVertex.new(x_value, y_value)
      end
    end
    array
  end

  def find_vertex(start_position)
    vertex_with_start_position = nil
    vertices.each { |vertex| vertex_with_start_position = vertex if vertex.coordinates == start_position }
    vertex_with_start_position
  end
end
