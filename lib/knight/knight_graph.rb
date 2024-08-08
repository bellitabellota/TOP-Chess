require_relative "knight_vertex"

class KnightGraph
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
        array << KnightVertex.new(x_value, y_value)
      end
    end
    array
  end

  def knight_moves(start_position, end_position)
    vertex_start = find_vertex(start_position)
    vertex_end = find_vertex(end_position)

    queue = [vertex_start]
    visited = [vertex_start]

    visited_vertices_during_move = recursive_bfs(queue, visited, vertex_end)

    puts "You made it in #{visited_vertices_during_move.length - 1} moves! Here's your path."
    visited_vertices_during_move.reverse.each { |vertex| p vertex.coordinates }
  end

  def recursive_bfs(queue, visited, vertex_end, vertices_visited_during_move = [])
    current_vertex = queue.shift
    current_vertex.coordinates

    if current_vertex == vertex_end
      vertices_visited_during_move << current_vertex
      return vertices_visited_during_move
    else
      current_vertex.reachable_coordinates.each do |coordinate|
        vertex = find_vertex(coordinate)
        unless visited.include?(vertex)
          queue << vertex
          visited << vertex
        end
      end

      recursive_bfs(queue, visited, vertex_end, vertices_visited_during_move)

      if current_vertex.reachable_coordinates.include?(vertices_visited_during_move[-1].coordinates)
        vertices_visited_during_move << current_vertex
      end
    end
    vertices_visited_during_move
  end

  def find_vertex(start_position)
    vertex_with_start_position = nil
    vertices.each { |vertex| vertex_with_start_position = vertex if vertex.coordinates == start_position }
    vertex_with_start_position
  end
end
