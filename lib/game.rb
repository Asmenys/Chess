# frozen_string_literal: true

require_relative 'display/display'
require_relative 'display/string'
require_relative 'pieces/piece_class'
require_relative 'self_check'
require_relative 'path'
require_relative 'node'
require_relative 'board'

class Game
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

  def is_square_friendly?(square_location)
    square_value = @board.get_value_of_square(square_location)
    if square_value.nil?
      false
    else
      square_value.team == fen_to_color
    end
  end

  def fen_to_color
    color_hash = { 'white' => 'w', 'black' => 'b' }
    color_hash.key(@active_color)
  end

  def is_king_in_check?
    kings_node = @board.find_king(fen_to_color)
    is_square_under_attack?(kings_node.index)
  end

  def is_square_under_attack?(square_location)
    attack_paths = @board.node_attack_paths(square_location)
    earliest_piece_nodes = get_earliest_piece_nodes_from_paths(attack_paths)
    earliest_piece_nodes = filter_out_friendly_nodes(earliest_piece_nodes)
    is_under_attack = can_pieces_move_to?(earliest_piece_nodes, square_location)
  end

  def can_pieces_move_to?(piece_nodes, movement_destination)
    can_move_to = false
    piece_nodes.each do |piece_node|
      piece = piece_node.value
      piece_location = piece_node.index
      if piece.possible_paths(piece_location).any? { |path| path.include?(movement_destination) }
        can_move_to = true
        break
      end
    end
    can_move_to
  end

  def filter_out_friendly_nodes(node_array)
    node_array.delete_if { |node| node.value.team == fen_to_color }
    node_array
  end

  def get_earliest_piece_nodes_from_paths(paths)
    earliest_piece_nodes = []
    paths.each do |path|
      earliest_piece_node = path.get_earliest_piece_node
      earliest_piece_nodes << earliest_piece_node unless earliest_piece_node.nil? || earliest_piece_node.value.nil?
    end
    earliest_piece_nodes
  end

  def would_leave_king_in_check?(current_location, movement_destination)
    @self_check.self_check?(current_location, movement_destination)
  end
end
