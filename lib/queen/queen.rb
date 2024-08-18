require_relative "queen_graph"

class Queen
  attr_reader :token
  attr_accessor :coordinates

  @@graph = QueenGraph.new
  @@start_coordinates = [[3, 0], [3, 7]]
  @@queen_tokens = ["\u265B", "\u2655"]

  def initialize(token_index)
    @token = @@queen_tokens[token_index]
    @coordinates = @@start_coordinates.pop
  end

  def self.graph
    @@graph
  end

  def self.coordinates
    @@start_coordinates
  end
end
