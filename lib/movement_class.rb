# frozen_string_literal: true

require 'pry-byebug'
class Movement
  include Path_utilities
  include Location_conversion
  attr_reader :board

  def initialize(board, active_color_clock, en_passant)
    @board = board
    @active_color_clock = active_color_clock
    @en_passant = en_passant
  end

  def self_to_fen
    fen_string = ''
    fen_string += "#{@active_color_clock.active_color} "
    fen_string += "#{castling_to_fen} "
    fen_string += "#{en_passant_to_fen} "
    fen_string
  end

  def castling_to_fen
    fen_string = ''
    fen_string += castling_to_fen_of_color('white')
    fen_string += castling_to_fen_of_color('black')
    if fen_string.empty?
      '-'
    else
      fen_string
    end
  end

  def no_legal_movements_left?
    piece_location_array = @board.get_piece_locations_of_color(@active_color_clock.fen_to_color)
    result = true
    piece_location_array.each do |piece_location|
      if can_piece_move?(piece_location)
        result = false
        break
      end
    end
    result
  end

  def can_piece_move?(piece_location)
    !get_possible_movement_directions(piece_location).empty?
  end

  def castling_to_fen_of_color(color)
    fen_string = ''
    kings_node = @board.find_king(color)
    king = kings_node.value
    unless king.has_moved
      king_side_rook = @board.get_value_of_square([get_base_row(color), 7])
      queen_side_rook = @board.get_value_of_square([get_base_row(color), 0])
      begin
        fen_string += 'k' unless king_side_rook.has_moved
      rescue StandardError
        true
      end
      begin
        fen_string += 'q' unless queen_side_rook.has_moved
      rescue StandardError
        true
      end
    end
    fen_case_size(color, fen_string)
  end

  def en_passant_to_fen
    if @en_passant.nil?
      '-'
    else
      en_passant_notation = location_to_selection(@en_passant)
    end
  end

  def fen_case_size(color, fen_string)
    case color
    when 'black'
      fen_string.downcase
    else
      fen_string.upcase
    end
  end

  def get_base_row(color)
    case color
    when 'black'
      0
    else
      7
    end
  end

  def will_result_in_capture?(movement_direction)
    destination_value = @board.get_value_of_square(movement_direction.destination)
    if destination_value.nil?
      movement_direction.destination == @en_passant
    else
      destination_value.team != @active_color_clock.fen_to_color
    end
  end

  def get_possible_movement_directions(current_location)
    piece = @board.get_value_of_square(current_location)
    movement_direction_array = []
    movement_direction_array += get_generic_movements(current_location)
    case piece.name
    when 'Pawn'
      movement_direction_array += get_one_step(current_location)
      movement_direction_array += get_two_step(current_location)
      movement_direction_array += get_pawn_captures(current_location)
      check_movement_directions_for_conversion(movement_direction_array)
    when 'King'
      movement_direction_array += get_castling(current_location)
    when 'Rook'
      movement_direction_array += get_castling(current_location)
    end
    filter_movements_for_check(movement_direction_array)
  end

  def check_movement_directions_for_conversion(movement_direction_array)
    movement_direction_array.each do |movement_direction|
      movement_direction.converts if will_convert_pawn?(movement_direction)
    end
  end

  def will_convert_pawn?(movement_direction)
    pawn = @board.get_value_of_square(movement_direction.current_location)
    result = false
    case pawn.team
    when 'black'
      result = true if movement_direction.destination[0] == 7
    when 'white'
      result = true if movement_direction.destination[0].zero?
    end
    result
  end

  def get_castling(current_location)
    movement_directions = []
    piece = @board.get_value_of_square(current_location)
    unless piece.can_castle? == false
      adjacent_paths = @board.get_adjacent_paths(current_location)
      delete_empty_paths_from_array(adjacent_paths)
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
        captureable_nodes << node unless node.value.team == @active_color_clock.fen_to_color
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
    pawn = @board.get_value_of_square(current_location)
    if pawn.can_two_step?
      indexed_two_step_path = [pawn.two_step(current_location)]
      two_step_path = path_indexes_to_paths(indexed_two_step_path).first
      if two_step_path.uninterrupted? && two_step_path.last_node.empty?
        destination = two_step_path.last_node.index
        en_passant_location = pawn.en_passant_location(current_location)
        two_step_directions << Movement_directions.new(current_location, destination, en_passant_location)
      end
    end
    two_step_directions
  end

  def get_one_step(current_location)
    one_step_directions = []
    pawn = @board.get_value_of_square(current_location)
    indexed_one_step_path = [pawn.one_step(current_location)]
    two_step_path = path_indexes_to_paths(indexed_one_step_path).first
    if two_step_path.last_node.empty?
      destination = two_step_path.last_node.index
      one_step_directions << Movement_directions.new(current_location, destination)
    end
    one_step_directions
  end

  def get_generic_movements(current_location)
    piece = @board.get_value_of_square(current_location)
    movement_direction_array = []
    possible_path_indexes = piece.possible_paths(current_location)
    delete_invalid_paths(possible_path_indexes)
    unless possible_path_indexes.empty?
      possible_paths = path_indexes_to_paths(possible_path_indexes)
      delete_empty_paths_from_array(possible_paths)
      valid_paths = setup_paths(piece.name, possible_paths)
      node_index_array = paths_to_location_indexes(valid_paths)
      movement_direction_array = movement_directions_from_location_index_array(current_location, node_index_array)
    end
    movement_direction_array
  end

  def setup_paths(_piece_name, path_array)
    paths_until_first_piece = paths_until_first_piece_from_path_array(path_array)
    paths_without_friendly_destinations = remove_friendly_destinations(paths_until_first_piece)
    valid_paths = filter_paths(paths_without_friendly_destinations)
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
      path.pop if !path.last_node.value.nil? && (path.last_node.value.team == @active_color_clock.fen_to_color)
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
      square_value.team == @active_color_clock.fen_to_color
    end
  end

  def would_leave_king_in_check?(movement_direction)
    result = false
    if king_exists?
      cloned_board = @board.clone_board
      piece_status_array = store_piece_status(movement_direction)
      current_en_passant = @en_passant
      execute_movement_directions(movement_direction)
      result = is_king_in_check?
      @en_passant = current_en_passant
      @board.board = cloned_board
      restore_piece_status(movement_direction, piece_status_array)
    end
    result
  end

  def store_piece_status(movement_direction)
    piece_status_array = []
    piece_status_array << @board.get_value_of_square(movement_direction.current_location).has_moved
    if movement_direction.moves_two_pieces?
      piece_status_array << @board.get_value_of_square(movement_direction.current_location_two)
    end
    piece_status_array
  end

  def restore_piece_status(movement_direction, piece_status_array)
    piece_one = @board.get_value_of_square(movement_direction.current_location)
    piece_one.has_moved = piece_status_array.first
    if movement_direction.moves_two_pieces?
      piece_two = @board.get_value_of_square(movement_direction.current_location_two)
      piece_two.has_moved = piece_status_array.last
    end
  end

  def king_exists?
    @board.find_king(@active_color_clock.fen_to_color).nil? == false
  end

  def execute_movement_directions(movement_directions)
    move_piece(movement_directions)
    update_piece_status(movement_directions)
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

  def update_piece_status(movement_direction)
    piece_one = @board.get_value_of_square(movement_direction.destination)
    piece_one.moved
    if movement_direction.moves_two_pieces?
      piece_two = @board.get_value_of_square(movement_direction.destination_two)
      piece_two.moved
    end
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
    case @active_color_clock.active_color
    when 'w'
      [@en_passant[0] + 1, @en_passant[1]]
    when 'b'
      [@en_passant[0] - 1, @en_passant[1]]
    end
  end

  def is_king_in_check?
    kings_node = @board.find_king(@active_color_clock.fen_to_color)
    is_square_under_attack?(kings_node.index)
  end

  def is_square_under_attack?(square_location)
    attack_paths = @board.node_attack_paths(square_location)
    earliest_piece_nodes = get_earliest_piece_nodes_from_paths(attack_paths)
    earliest_piece_nodes = filter_out_friendly_nodes(earliest_piece_nodes)
    is_under_attack = can_pieces_attack?(earliest_piece_nodes, square_location)
  end

  def can_pieces_attack?(piece_nodes, movement_destination)
    can_move_to = false
    piece_nodes.each do |piece_node|
      piece = piece_node.value
      piece_location = piece_node.index
      if piece.possible_attack_paths(piece_location).any? { |path| path.include?(movement_destination) }
        can_move_to = true
        break
      end
    end
    can_move_to
  end

  def filter_out_friendly_nodes(node_array)
    node_array.delete_if { |node| node.value.team == @active_color_clock.fen_to_color }
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
