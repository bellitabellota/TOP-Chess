require_relative "knight/knight"

class PieceSet
  attr_reader :knight1, :knight2

  def initialize(token_index)
    @knight1 = Knight.new(token_index)
    @knight2 = Knight.new(token_index)
  end
end
