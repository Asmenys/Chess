# frozen_string_literal: true

require_relative 'display/display'

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

  def validate_move_array(array)
    array.each do |location|
      array.delete(location) if valid_location?(location) == false
    end
  end

  def create_piece(colour, type)
    Object.const_get(type).new(colour, type)
  end

  def set_square_to(location, value)
    @board[location[0]][location[1]] = value
  end

  def valid_location?(location)
    result = false
    result = true if valid_dimensions?(location) && empty_location?(location)
    result
  end

  def valid_dimensions?(location)
    result = false
    result = true if valid_index?(location[0]) && valid_index?(location[1])
    result
  end

  def valid_index?(index)
    result = false
    result = true if index >= 0 && (index < 8)
    result
  end

  def get_value_of_square(location)
    @board[location[0]][location[1]]
  end

  def empty_location?(location)
    get_value_of_square(location).nil?
  end
end
