# frozen_string_literal: true

require_relative 'display/display'
require_relative 'display/string'
require_relative 'board'
require_relative 'node_validation_module'
require_relative 'path_validation_module'
require_relative 'pieces/piece_class'
require_relative 'self_check'

class Game
  include Node_validation
  include Path_validation
  attr_reader :full_turns, :half_turn, :en_passant, :active_color
  attr_accessor :board

  def initialize(board, active_color = nil, en_passant = nil, full_turn = nil, half_turn = nil)
    @board = board
    @full_turns = full_turn
    @half_turn = half_turn
    @en_passant = en_passant
    @active_color = active_color
    @self_check = Self_check.new(self)
  end

  def get_valid_end_points(current_location)
    possible_end_points = get_possible_end_points(current_location)
    valid_end_points = []
    possible_end_points.each do |end_point|
      valid_end_points << end_point unless would_leave_king_in_check?(current_location, end_point)
    end
    valid_end_points
  end

  def is_king_in_check?(kings_location)
    king = @board.get_value_of_square(kings_location)
    attack_paths = king.attack_paths(kings_location)
    check_paths_for_king_check(attack_paths, kings_location)
  end

  def would_leave_king_in_check?(current_location, movement_destination)
    @self_check.self_check?(current_location, movement_destination)
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
end
