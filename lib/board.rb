# frozen_string_literal: true

class Board
  include Knight_moveset
  include Diagonal_moveset
  include Horizontal_moveset
  attr_reader :board

  include Display
  def initialize
    @board = Array.new(8) { Array.new(8) }
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

  def valid_location?(location)
    result = false
    result = true if valid_dimensions?(location) && empty_location?(location)
    result
  end

  def find_king(kings_color)
    location = nil
    temp_row = 0
    while temp_row <= 7
      temp_column = 0
      while temp_column <= 7
        node_index = [temp_row, temp_column]
        node_value = get_value_of_square(node_index)
        if node_value.instance_of?(King) && (node_value.team == kings_color)
          location = node_index
          break
        end
        temp_column += 1
      end
      temp_row += 1
      temp_column = 0
    end
    kings_node = Node.new(location, get_value_of_square(location))
  end

  def node_attack_paths(node_location)
    array_of_path_node_indexes = get_attack_path_nodes(node_location)
    array_of_path_nodes = []
    array_of_path_node_indexes.each do |path_of_indexes|
      array_of_path_nodes << indexes_to_nodes(path_of_indexes)
    end
    array_of_paths = path_nodes_to_path(array_of_path_nodes)
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

  def indexes_to_nodes(array_of_path_node_indexes)
    array_of_path_nodes = []
    array_of_path_node_indexes.each do |index|
      node_value = get_value_of_square(index)
      array_of_path_nodes << Node.new(index, node_value)
    end
    array_of_path_nodes
  end

  def path_nodes_to_path(array_of_path_nodes)
    array_of_paths = []
    array_of_path_nodes.each do |path_node_array|
      array_of_paths << Path.new(path_node_array)
    end
    array_of_paths
  end

  def filter_paths(array_of_paths)
    array_of_paths.keep_if(&:valid?)
    array_of_paths.delete_if(&:empty?)
    array_of_paths
  end
end
