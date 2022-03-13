# frozen_string_literal: true

class Board
  include Knight_moveset
  include Diagonal_moveset
  include Horizontal_moveset
  attr_accessor :board

  include Display
  include Path_utilities
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def self_to_fen
    fen_string = ''
    free_space_index = 0
    @board.each_with_index do |row, row_index|
      row.each do |node|
        if node.nil?
          free_space_index += 1
        else
          fen_string += free_space_index.to_s unless free_space_index.zero?
          free_space_index = 0
          fen_string += node.self_to_fen
        end
      end
      fen_string += free_space_index.to_s unless free_space_index.zero?
      free_space_index = 0
      fen_string += '/' unless row_index == 7
    end
    fen_string
  end

  def clone_board
    cloned_board = Array.new(8) { Array.new(8) }
    @board.each_with_index do |row, row_index|
      row.each_with_index do |node, column_index|
        cloned_board[row_index][column_index] = node
      end
    end
    cloned_board
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

  def get_piece_locations_of_color(color)
    location_index_array = []
    @board.each_with_index do |row, row_index|
      row.each_with_index do |piece, column_index|
        location_index_array << [row_index, column_index] if !piece.nil? && piece.team == color
      end
    end
    location_index_array
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

  def get_adjacent_paths(current_location)
    array_of_path_node_indexes = []
    array_of_path_node_indexes << get_path_on_axis(current_location, 1, -1)
    array_of_path_node_indexes << get_path_on_axis(current_location, 1, 1)
    adjacent_paths = array_of_path_node_indexes_to_paths(array_of_path_node_indexes)
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
