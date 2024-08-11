require_relative "knight/knight"
require_relative "king/king"
require_relative "rook/rook"
require_relative "bishop/bishop"
require_relative "queen/queen"
require_relative "pawn/pawn"

class Player
  attr_reader :name, :set_color, :set

  @@available_set_colors = ["white", "black"]

  def initialize
    @name = nil
    @set_color = nil
    @set = []
  end

  def request_name(player_number)
    puts "Please enter name of player #{player_number}:"
    player_name = gets.chomp
    @name = player_name
  end

  def request_preferred_set_color
    puts "Time to choose the color of the set you want to play. Press 'w' for white or 'b' for black. Please enter your choice:"
    color = player_set_color

    assign_choice(color)

    puts "#{name} chose #{set_color}."
  end

  def assign_choice(color)
    color == 'w' ? @set_color = @@available_set_colors.shift : @set_color = @@available_set_colors.pop
  end

  def player_set_color
    loop do
      input = gets.chomp

      return input.downcase if ["w", "b"].include?(input.downcase)

      puts "Invalid input. Try again:"
    end
  end

  def assign_remaining_set_color
    @set_color = @@available_set_colors.pop
    puts "#{name} plays #{set_color}."
  end

  def assign_pieces(token_index, player)
    set.push(King.new(token_index))
    set.push(Queen.new(token_index))

    2.times do
      set.push(Knight.new(token_index))
      set.push(Rook.new(token_index))
      set.push(Bishop.new(token_index))
    end

    create_pawns(token_index, player)
  end

  def create_pawns(token_index, player)
    8.times do
      set.push(Pawn.new(token_index))
    end

    if player.set[-1].coordinates[1] == 6
      Pawn.graph_player1 = PawnGraph.new(player)
    else
      Pawn.graph_player2 = PawnGraph.new(player)
    end
  end
end
