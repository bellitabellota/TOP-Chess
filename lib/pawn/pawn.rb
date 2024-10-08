require_relative "pawn_graph"

class Pawn
  attr_reader :token, :start_position
  attr_accessor :coordinates

  @@graph_player_black = nil
  @@graph_player_white = nil
  @@start_coordinates = [[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6]]
  @@pawn_tokens = ["\u265F", "\u2659"]

  def initialize(token_index)
    @token = @@pawn_tokens[token_index]
    @coordinates = @@start_coordinates.pop
    @start_position = coordinates ##check if this should be made a constant
  end

  def self.graph_player_white
    @@graph_player1
  end

  def self.graph_player_white=(player)
    @@graph_player1 = player
  end

  def self.graph_player_black
    @@graph_player2
  end

  def self.graph_player_black=(player)
    @@graph_player2 = player
  end

  def self.coordinates
    @@start_coordinates
  end
end
