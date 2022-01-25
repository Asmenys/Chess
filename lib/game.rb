# frozen_string_literal: true

require_relative 'display/display'
require_relative 'display/string'
require_relative 'board'
require_relative 'node_validation_module'
require_relative 'path_validation_module'
require_relative 'pieces/piece_class'

class Game
  include Node_validation
  include Path_validation
  attr_reader :board, :full_turns, :half_turn, :en_passant, :active_color

  def initialize(board, active_color = nil, en_passant = nil, full_turn = nil, half_turn = nil)
    @board = board
    @full_turns = full_turn
    @half_turn = half_turn
    @en_passant = en_passant
    @active_color = active_color
  end

  def show_board
    @board.display_board
  end

  def move_piece(current_location, result_location, board = @board)
    piece = board.get_value_of_square(current_location)
    board.set_square_to(current_location, nil)
    board.set_square_to(result_location, piece)
  end

  def get_possible_valid_end_points(current_location)
    valid_end_points = []
    piece = @board.get_value_of_square(current_location)
    possible_paths = piece.possible_paths(current_location)
    valid_possible_paths = validate_array_of_paths(possible_paths)
    valid_possible_paths.each do |path|
      path.each do |node|
        valid_end_points << node unless valid_end_points.include?(node) || is_square_friendly?(piece, node)
      end
    end
    valid_end_points
  end

  def would_leave_king_in_check?(_current_location, _movement_destination)
    alternate_board = @board
  end

  def find_king(kings_color)
    team_hash = { 'black' => 'b', 'white' => 'w' }
    kings_color = team_hash.key(kings_color)
    location = nil
    temp_row = 0
    while temp_row <= 7
      temp_column = 0
      while temp_column <= 7
        node_index = [temp_row, temp_column]
        node_value = @board.get_value_of_square(node_index)
        if node_value.instance_of?(King) && (node_value.team == kings_color)
          location = node_index
          break
        end
        temp_column += 1
      end
      temp_row += 1
      temp_column = 0
    end
    location
  end

  def is_square_friendly?(current_piece, square_location)
    friendly_color = current_piece.team
    square_value = @board.get_value_of_square(square_location)
    if square_value.nil?
      false
    else
      square_value.team == friendly_color
    end
  end

  def is_king_in_check?(kings_location)
    king = board.get_value_of_square(kings_location)
    attack_paths = king.attack_paths(kings_location)
    check_paths_for_king_check(attack_paths, kings_location)
  end

  def check_paths_for_king_check(attack_paths, kings_location)
    is_in_check = false
    attack_paths = clean_paths(attack_paths)
    kings_color = @board.get_value_of_square(kings_location).team
    attacking_pieces = get_attacking_pieces_from_path_array(attack_paths, kings_color)
    attacking_pieces.each do |attacking_piece|
      is_in_check = true if does_path_include?(attacking_piece, kings_location)
    end
    is_in_check
  end

  def does_path_include?(piece_info, object_location)
    piece_info[0].possible_paths(piece_info[1]).any? { |path| path.include?(object_location) }
  end

  def get_attacking_pieces_from_path_array(attack_paths, kings_color)
    attacking_pieces = []
    attack_paths.each do |path|
      attacking_piece = get_earliest_piece_with_location(path)
      attacking_pieces << attacking_piece unless attacking_piece.nil? || attacking_piece[0].team == kings_color
    end
    attacking_pieces
  end

  def get_earliest_piece_with_location(path)
    piece = nil
    location = nil
    piece_found = false
    path.each do |node|
      node_value = @board.get_value_of_square(node)
      next if node_value.nil?

      piece = node_value
      location = node
      piece_found = true
      break
    end
    [piece, location] if piece_found
  end

  def validate_array_of_paths(array)
    valid_paths = []
    array = clean_paths(array)
    array.each do |path|
      valid_paths << path_until_first_piece(path)
    end
  end

  def path_until_first_piece(array)
    path = []
    array.each do |node|
      node_value = @board.get_value_of_square(node)
      path << node
      if node_value.nil?
      else
        break
      end
    end
    path
  end
end
