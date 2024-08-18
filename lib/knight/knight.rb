require_relative "knight_graph"

class Knight
  attr_reader :token
  attr_accessor :current_position, :coordinates

  @@graph = KnightGraph.new
  @@start_coordinates = [[1, 0], [6, 0], [1, 7], [6, 7]]
  @@knight_tokens = ["\u265E", "\u2658"]

  def initialize(token_index)
    @token = @@knight_tokens[token_index]
    @coordinates = @@start_coordinates.pop
  end

  def self.graph
    @@graph
  end

  def self.coordinates
    @@start_coordinates
  end
end
