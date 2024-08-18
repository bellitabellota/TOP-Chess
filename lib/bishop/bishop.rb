require_relative "bishop_graph"

class Bishop
  attr_reader :token
  attr_accessor :coordinates

  @@graph = BishopGraph.new
  @@start_coordinates = [[2, 0], [5, 0], [2, 7], [5, 7]]
  @@bishop_tokens = ["\u265D", "\u2657"]

  def initialize(token_index)
    @token = @@bishop_tokens[token_index]
    @coordinates = @@start_coordinates.pop
  end

  def self.graph
    @@graph
  end

  def self.coordinates
    @@start_coordinates
  end
end
