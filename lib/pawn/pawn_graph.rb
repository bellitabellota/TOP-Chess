require_relative "pawn_vertex"

class PawnGraph
  attr_accessor :vertices

  def initialize(player)
    @vertices = create_vertices(player)
  end

  def create_vertices(player)
    array = []
    value_on_x_axis = (0..7)
    value_on_y_axis = (0..7)

    value_on_x_axis.each do |x_value|
      value_on_y_axis.each do |y_value|
        array << PawnVertex.new(x_value, y_value, player)
      end
    end
    array
  end
end
