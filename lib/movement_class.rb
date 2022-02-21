# frozen_string_literal: true

require 'pry-byebug'
class Movement
  include Path_utilities
  attr_reader :board

  def initialize(board, active_color, en_passant)
    @board = board
    @active_color = active_color
    @en_passant = en_passant
  end

  def get_possible_movement_directions(current_location)
    movement_direction_array = []
    movement_direction_array += get_castling(current_location)
    movement_direction_array += get_two_step(current_location)
    movement_direction_array += get_generic_movements(current_location)
    movement_direction_array += get_pawn_captures(current_location)
    filter_movements_for_check(movement_direction_array)
  end

  def update_active_color
    @active_color = if @active_color == 'w'
                      'b'
                    else
                      'w'
                    end
  end

  def get_castling(current_location)
    movement_directions = []
    piece = @board.get_value_of_square(current_location)
    unless piece.can_castle? == false
      adjacent_paths = @board.get_adjacent_paths(current_location)
      adjacent_paths = paths_until_first_piece_from_path_array(adjacent_paths)
      remove_paths_that_dont_end_with_a_piece(adjacent_paths)
      castling_paths = filter_paths_for_castling(adjacent_paths)
      movement_directions = castling_paths_to_movement_directions(current_location, castling_paths)
    end
    movement_directions
  end

  def get_pawn_captures(current_location)
    movement_directions = []
    piece = @board.get_value_of_square(current_location)
    if piece.instance_of?(Pawn)
      capture_node_indexes = piece.capture_nodes(current_location)
      capture_nodes = @board.indexes_to_nodes(capture_node_indexes)
      valid_capture_nodes = filter_captureable_nodes(capture_nodes)
      location_index_array = array_of_nodes_to_indexes(valid_capture_nodes)
      movement_directions += movement_directions_from_location_index_array(current_location, location_index_array)
    end
    movement_directions
  end

  def filter_captureable_nodes(node_array)
    captureable_nodes = []
    node_array.each do |node|
      if node.empty?
        captureable_nodes << node unless @en_passant != node.index
      else
        captureable_nodes << node unless node.value.team == fen_to_color
      end
    end
    captureable_nodes
  end

  def array_of_nodes_to_indexes(array_of_nodes)
    location_index_array = []
    array_of_nodes.each do |node|
      location_index_array << node.index
    end
    location_index_array
  end

  def castling_paths_to_movement_directions(current_location, castling_paths)
    movement_directions = []
    castling_paths.each do |path|
      movement_directions << Movement_directions.new(current_location, path.last_node.index, nil, path.last_node.index,
                                                     current_location)
    end
    movement_directions
  end

  def filter_paths_for_castling(array_of_paths)
    castling_paths = []
    array_of_paths.each do |path|
      next unless path.last_node.value.can_castle?

      castling_paths << path if path.nodes.none? { |node| is_square_under_attack?(node.index) }
    end
    castling_paths
  end

  def get_two_step(current_location)
    two_step_directions = []
    piece = @board.get_value_of_square(current_location)
    unless piece.has_moved || piece.class != Pawn
      destination = piece.two_step(current_location).last
      en_passant_location = piece.en_passant_location(current_location)
      two_step_directions << Movement_directions.new(current_location, destination, en_passant_location)
    end
    two_step_directions
  end

  def get_generic_movements(current_location)
    piece = @board.get_value_of_square(current_location)
    possible_paths = path_indexes_to_paths(piece.possible_paths(current_location))
    paths_until_first_piece = paths_until_first_piece_from_path_array(possible_paths)
    paths_without_friendly_destinations = remove_friendly_destinations(paths_until_first_piece)
    valid_paths = filter_paths(paths_without_friendly_destinations)
    node_index_array = paths_to_location_indexes(valid_paths)
    movement_directions = movement_directions_from_location_index_array(current_location, node_index_array)
  end

  def movement_directions_from_location_index_array(current_location, node_index_array)
    movement_directions = []
    node_index_array.each do |destination|
      movement_directions << movement_directions_from_location_index(current_location, destination)
    end
    movement_directions
  end

  def movement_directions_from_location_index(current_location, destination, current_location_two = nil, destination_two = nil, en_passant = nil)
    Movement_directions.new(current_location, destination, en_passant, current_location_two, destination_two)
  end

  def remove_friendly_destinations(array_of_paths)
    paths_without_friendly_pieces = []
    array_of_paths.each do |path|
      path.pop if !path.last_node.value.nil? && (path.last_node.value.team == fen_to_color)
      paths_without_friendly_pieces << path
    end
    paths_without_friendly_pieces
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

  def filter_movements_for_check(movement_directions_array)
    valid_movements = []
    movement_directions_array.each do |movement_direction|
      valid_movements << movement_direction unless would_leave_king_in_check?(movement_direction)
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

  def would_leave_king_in_check?(movement_directions)
    result = false
    if king_exists?
      cloned_board = @board.clone_board
      current_en_passant = @en_passant
      execute_movement_directions(movement_directions)
      result = is_king_in_check?
      @en_passant = current_en_passant
      @board.board = cloned_board
    end
    result
  end

  def king_exists?
    @board.find_king(fen_to_color).nil? == false
  end

  def execute_movement_directions(movement_directions)
    move_piece(movement_directions)
    capture_en_passant(movement_directions)
    delete_moved_pieces(movement_directions)
  end

  def move_piece(movement_directions)
    piece = @board.get_value_of_square(movement_directions.current_location)
    if movement_directions.moves_two_pieces?
      piece_two = @board.get_value_of_square(movement_directions.current_location_two)
      @board.set_square_to(movement_directions.destination_two, piece_two)
    end
    @board.set_square_to(movement_directions.destination, piece)
  end

  def capture_en_passant(movement_directions)
    if movement_directions.destination == @en_passant
      @board.set_square_to(get_pawn_location_from_en_passant, nil)
      @en_passant = nil
    end
  end

  def delete_moved_pieces(movement_directions)
    @board.set_square_to(movement_directions.current_location, nil) unless movement_directions.moves_two_pieces?
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
