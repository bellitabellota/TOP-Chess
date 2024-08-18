require_relative "rook_graph"

class Rook
  attr_reader :token
  attr_accessor :coordinates

  @@graph = RookGraph.new
  @@start_coordinates = [[0, 0], [7, 0], [0, 7], [7, 7]]
  @@rook_tokens = ["\u265C", "\u2656"]

  def initialize(token_index)
    @token = @@rook_tokens[token_index]
    @coordinates = @@start_coordinates.pop
  end

  def self.graph
    @@graph
  end

  def self.coordinates
    @@start_coordinates
  end
end
