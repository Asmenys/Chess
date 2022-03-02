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
  include Display
  include Path_utilities
  attr_reader :full_turns, :half_turn, :en_passant, :active_color, :movement
  attr_accessor :board

  def initialize(board, movement_manager, full_turn = nil, half_turn = nil)
    @board = board
    @full_turns = full_turn
    @half_turn = half_turn
    @movement = movement_manager
  end

  def get_valid_piece_selection
    promt_to_choose_piece
    until valid_piece_selection?(selection = get_piece_selection)
      prompt_to_choose_piece_after_invalid_choice
    end
    selection
  end

  def get_valid_destination_selection(destination_count)
    prompt_to_choose_destination
    until valid_destination_selection?(choice = gets.to_i, destination_count)
      promt_to_choose_destination_after_invalid_choice
    end
    choice
  end

  def valid_destination_selection?(destination_choice, destination_count)
    destination_choice.positive? && (destination_choice <= destination_count)
  end

  def movement_directions_to_notation(movement_direction_array)
    destination_array = movement_directions_to_destinations(movement_direction_array)
    notation_array = destinations_to_notation(destination_array)
  end

  def movement_directions_to_destinations(movement_direction_array)
    destination_array = []
    movement_direction_array.each do |movement_direction|
      destination_array << movement_direction.destination
    end
    destination_array
  end

  def destinations_to_notation(destination_array)
    notation_array = []
    destination_array.each do |destination|
      notation_array << location_to_selection(destination)
    end
    notation_array
  end

  def get_piece_selection
    selection = gets.chomp
  end

  def has_player_lost?
    no_legal_movements_left?
  end

  def increment_full_turns
    @full_turns += 1
  end

  def increment_half_turns
    @half_turn += 1
  end

  def reset_half_turns
    @half_turn = 0
  end

  def valid_piece_selection?(selection)
    result = false
    if is_notation?(selection)
      location = selection_to_location(selection)
      if valid_location?(location) && (!@board.empty_location?(location) && (@board.get_value_of_square(location).team == @movement.fen_to_color))
        result = true
      end
    end
    result
  end

  def selection_to_location(selection)
    selection = selection.chars
    row_index = selection.last.to_i - 1
    column_index = selection.first.ord - 97
    [row_index, column_index]
  end

  def location_to_selection(location)
    selection = ''
    selection += (location[1] + 97).chr
    selection += (location[0] + 1).to_s
    selection
  end

  def is_notation?(selection)
    result = false
    if selection.length == 2
      selection = selection.chars
      result = true if is_a_letter?(selection.first) && is_a_number?(selection.last)
    end
    result
  end

  def is_a_letter?(character)
    character.match?(/[a-h]/)
  end

  def is_a_number?(character)
    character.match?(/[1-9]/)
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
