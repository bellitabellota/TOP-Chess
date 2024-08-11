require_relative "king_graph"

class King
  attr_reader :token, :coordinates

  @@graph = KingGraph.new
  @@start_coordinates = [[4, 0], [4, 7]]
  @@king_tokens = ["\u265A", "\u2654"]

  def initialize(token_index)
    @token = @@king_tokens[token_index]
    @coordinates = @@start_coordinates.pop
  end

  def self.graph
    @@graph
  end

  def self.coordinates
    @@start_coordinates
  end
end
