# frozen_string_literal: true

require 'pry-byebug'
class Movement
  attr_reader :board

  def initialize(board, active_color, en_passant)
    @board = board
    @active_color = active_color
    @en_passant = en_passant
  end

  def get_possible_movements(current_location)
    piece_node = Node.new(@board.get_value_of_square(current_location), current_location)
    possible_paths = path_indexes_to_paths(piece_node.value.possible_paths(current_location))
    paths_until_first_piece = paths_until_first_piece_from_path_array(possible_paths)
    paths_without_friendly_pieces = []
    paths_until_first_piece.each do |path|
      path.pop if path.last_node.value.team == piece_node.value.team
      paths_without_friendly_pieces << path
    end
  end

  def filter_paths_for_friendly_pieces(array_of_paths)
    paths_without_friendly_pieces = []
    array_of_paths.each do |path|
      path.pop if !path.last_node.value.nil? && (path.last_node.value.team == fen_to_color)
      paths_without_friendly_pieces << path
    end
    paths_without_friendly_pieces
  end

  def paths_until_first_piece_from_path_array(array_of_paths)
    paths_until_first_piece = []
    array_of_paths.each do |path|
      paths_until_first_piece << path.path_until_first_piece
    end
    paths_until_first_piece
  end

  def path_indexes_to_paths(path_index_array)
    paths = []
    array_of_path_node_arrays = []
    path_index_array.each do |path_of_indexes|
      array_of_path_node_arrays << @board.indexes_to_nodes(path_of_indexes)
    end
    array_of_path_node_arrays.each do |array_of_path_nodes|
      paths << @board.path_nodes_to_path(array_of_path_nodes)
    end
    paths
  end

  def filter_movements_for_check(current_location, movement_array)
    valid_movements = []
    movement_array.each do |movement_destination|
      valid_movements << movement_destination unless would_leave_king_in_check?(current_location, movement_destination)
    end
    valid_movements
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

  def would_leave_king_in_check?(from, to)
    destination_value = @board.get_value_of_square(to)
    move_piece(from, to)
    result = is_king_in_check?
    move_piece(to, from)
    @board.set_square_to(to, destination_value)
    result
  end

  def move_piece(from, to)
    piece = @board.get_value_of_square(from)
    @board.set_square_to(from, nil)
    @board.set_square_to(to, piece)
  end

  def get_pawn_location_from_en_passant
    case @active_color
    when 'w'
      [@en_passant[0] + 1, @en_passant[1]]
    when 'b'
      [@en_passant[0] - 1, @en_passant[1]]
    end
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
end
