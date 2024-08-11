require_relative "player"
require_relative "game_preparation"

class Game
  attr_reader :player1, :player2
  attr_accessor :player1_set, :player2_set, :board, :tboard, :current_player

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Array.new(8) { Array.new(8, nil) }
    @tboard = Array.new(8) { Array.new(8, " ") }
    @current_player = player1
  end

  include GamePreparation

  def play_game
    set_up_game

    display_board

    make_player_move
  end

  def make_player_move
    request_player_move
  end

  def request_player_move
    piece_to_move = choose_piece_for_move

    target_field = choose_target_field(piece_to_move)
  end

  def choose_target_field(piece_to_move)
    target_field = position_of_target_field(piece_to_move)
    ##check if this target field is a possible move
  end

  def position_of_target_field(piece_to_move)
    puts "#{current_player.name} where do you want to place your #{piece_to_move.class}? Please enter the coordinates:"

    loop do
      input = gets.chomp
      return input if verify_input(input)

      puts "Invalid input. Try again:"
    end
  end

  def choose_piece_for_move
    loop do
      piece_position = position_of_piece

      board_indexes = convert_to_indexes(piece_position)

      return board[board_indexes[0]][board_indexes[1]] if field_contains_piece_of_player?(board_indexes)

      puts "The field you entered does not contain a piece of your set."
      puts
    end
  end

  def field_contains_piece_of_player?(board_indexes)
    current_player.set.include?(board[board_indexes[0]][board_indexes[1]])
  end

  def convert_to_indexes(piece_position)
    array = piece_position.split("")

    array[0] = convert_letter(array[0].downcase)
    array[1] = array[1].to_i - 1

    array
  end

  def convert_letter(input_letter)
    letters = ("a".."h").to_a
    number = nil
    letters.each_with_index{ |letter, index| number = index if letter == input_letter }
    number
  end

  def position_of_piece
    puts "#{current_player.name} enter the coordinates of the piece you want to move (e.g. b2):"

    loop do
      input = gets.chomp
      return input if verify_input(input)

      puts "Invalid input. Try again:"
    end
  end

  def verify_input(input)
    return false if input.length != 2

    input = input.split("")

    return false unless verify_first_character(input[0]) && verify_second_character(input[1])

    true
  end

  def verify_second_character(second_character)
    ("1".."8").include?(second_character)
  end

  def verify_first_character(first_character)
    ("a".."h").include?(first_character.downcase)
  end

  def switch_current_player
    if current_player == player1
      self.current_player = player2
    else
      self.current_player = player1
    end
  end

  private

  def display_board
    puts
    puts "    a   b   c   d   e   f   g   h  "
    puts "   ------------------------------- "
    puts "8 | #{tboard[0][7]} | #{tboard[1][7]} | #{tboard[2][7]} | #{tboard[3][7]} | #{tboard[4][7]} | #{tboard[5][7]} | #{tboard[6][7]} | #{tboard[7][7]} | 8"
    puts "   ------------------------------- "
    puts "7 | #{tboard[0][6]} | #{tboard[1][6]} | #{tboard[2][6]} | #{tboard[3][6]} | #{tboard[4][6]} | #{tboard[5][6]} | #{tboard[6][6]} | #{tboard[7][6]} | 7"
    puts "   ------------------------------- "
    puts "6 | #{tboard[0][5]} | #{tboard[1][5]} | #{tboard[2][5]} | #{tboard[3][5]} | #{tboard[4][5]} | #{tboard[5][5]} | #{tboard[6][5]} | #{tboard[7][5]} | 6"
    puts "   ------------------------------- "
    puts "5 | #{tboard[0][4]} | #{tboard[1][4]} | #{tboard[2][4]} | #{tboard[3][4]} | #{tboard[4][4]} | #{tboard[5][4]} | #{tboard[6][4]} | #{tboard[7][4]} | 5"
    puts "   ------------------------------- "
    puts "4 | #{tboard[0][3]} | #{tboard[1][3]} | #{tboard[2][3]} | #{tboard[3][3]} | #{tboard[4][3]} | #{tboard[5][3]} | #{tboard[6][3]} | #{tboard[7][3]} | 4"
    puts "   ------------------------------- "
    puts "3 | #{tboard[0][2]} | #{tboard[1][2]} | #{tboard[2][2]} | #{tboard[3][2]} | #{tboard[4][2]} | #{tboard[5][2]} | #{tboard[6][2]} | #{tboard[7][2]} | 3"
    puts "   ------------------------------- "
    puts "2 | #{tboard[0][1]} | #{tboard[1][1]} | #{tboard[2][1]} | #{tboard[3][1]} | #{tboard[4][1]} | #{tboard[5][1]} | #{tboard[6][1]} | #{tboard[7][1]} | 2"
    puts "   ------------------------------- "
    puts "1 | #{tboard[0][0]} | #{tboard[1][0]} | #{tboard[2][0]} | #{tboard[3][0]} | #{tboard[4][0]} | #{tboard[5][0]} | #{tboard[6][0]} | #{tboard[7][0]} | 1"
    puts "   ------------------------------- "
    puts "    a   b   c   d   e   f   g   h  "
    puts
  end
end
