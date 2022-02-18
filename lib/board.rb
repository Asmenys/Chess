# frozen_string_literal: true

class Board
  include Knight_moveset
  include Diagonal_moveset
  include Horizontal_moveset
  attr_reader :board

  include Display
  include Path_utilities
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def clone
    duplicate_board = Board.new
    @board.each_with_index do |row, row_index|
      row.each_with_index do |node, column_index|
        current_location = [row_index, column_index]
        duplicate_board.set_square_to(current_location, node)
      end
    end
    duplicate_board
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

  def find_king(kings_color)
    kings_node = nil
    @board.each_with_index do |row, row_index|
      row.each_with_index do |node_value, column_index|
        node_index = [row_index, column_index]
        if node_value.instance_of?(King) && (node_value.team == kings_color)
          kings_node = Node.new(node_index, node_value)
          break
        end
      end
    end
    kings_node
  end

  def node_attack_paths(node_location)
    array_of_path_node_indexes = get_attack_path_nodes(node_location)
    delete_invalid_paths(array_of_path_node_indexes)
    delete_empty_node_indexes(array_of_path_node_indexes)
    array_of_paths = array_of_path_node_indexes_to_paths(array_of_path_node_indexes)
    filter_paths(array_of_paths)
    array_of_paths
  end

  def get_attack_path_nodes(node_location)
    array_of_path_node_indexes = []
    array_of_path_node_indexes += moves_on_axis(node_location)
    array_of_path_node_indexes += get_knight_movements(node_location)
    array_of_path_node_indexes += diagonal_movement_paths(node_location)
    array_of_path_node_indexes
  end

  def array_of_path_node_indexes_to_paths(array_of_path_node_indexes)
    paths = []
    array_of_path_node_indexes.each do |path_of_indexes|
      path_of_indexes = indexes_to_nodes(path_of_indexes)
      paths << path_nodes_to_path(path_of_indexes)
    end
    paths.flatten
  end

  def indexes_to_nodes(array_of_path_node_indexes)
    array_of_path_nodes = []
    array_of_path_node_indexes.each do |index|
      node_value = get_value_of_square(index)
      array_of_path_nodes << Node.new(index, node_value)
    end
    array_of_path_nodes
  end
end
