# frozen_string_literal: true

require_relative 'display/display'
require_relative 'display/string'
require_relative 'pieces/piece_class'
require_relative 'path'
require_relative 'node'
require_relative 'path_utilities_module'
require_relative 'movement_directions'
require_relative 'board'
require_relative 'movement_class'

class Game
  attr_reader :full_turns, :half_turn, :en_passant, :active_color, :movement
  attr_accessor :board

  def initialize(board, movement_manager, full_turn = nil, half_turn = nil)
    @board = board
    @full_turns = full_turn
    @half_turn = half_turn
    @movement = movement_manager
  end

  def has_player_lost?
    no_legal_movements_left?
  end

  def increment_full_turns
    @full_turns += 1
  end

  def valid_selection?(selection)
    result = false
    location = selection_to_location(selection)
    if valid_location?(location) && !@board.empty_location?(location) && (@board.get_value_of_square(location).team == @movement.fen_to_color)
      result = true
    end
    result
  end

  def selection_to_location(selection)
    row_index = selection.first.to_i - 1
    column_index = selection.last.ord - 97
    [row_index, column_index]
  end

  def no_legal_movements_left?
    piece_location_array = @board.get_piece_locations_of_color(@movement.fen_to_color)
    result = true
    piece_location_array.each do |piece_location|
      unless @movement.get_possible_movement_directions(piece_location).empty?
        result = false
        break
      end
    end
    result
  end
end
