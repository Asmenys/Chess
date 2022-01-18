# frozen_string_literal: true

class Board
  attr_reader :board

  include Display
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def add_piece(team_colour, type, location)
    piece = create_piece(team_colour, type)
    set_square_to(location, piece)
  end

  def create_piece(colour, type)
    Object.const_get(type).new(colour, type)
  end

  def set_square_to(location, value)
    @board[location[0]][location[1]] = value
  end

  def get_value_of_square(location)
    @board[location[0]][location[1]]
  end

  def empty_location?(location)
    get_value_of_square(location).nil?
  end

  def valid_location?(location)
    result = false
    result = true if valid_dimensions?(location) && empty_location?(location)
    result
  end
end
