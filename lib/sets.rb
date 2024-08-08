require_relative "knight/knight"

class Set
  attr_reader :knight1, :knight2

  def initialize(token_index)
    @knight1 = Knight.new(token_index)
    @knight2 = Knight.new(token_index)
  end
end

=begin
    set1 = Set.new(0)
    p set1.knight1
    p set1.knight1.token
    p set1.knight1.coordinates
    p set1.knight2
    puts
    p set1  #FOR SOME REASON THIS GIVES AN ERROR
=end

#p Knight.coordinates


#set2 = Set.new(1)
#p set2.knight1
#p set2.knight2
#p Knight.coordinates
