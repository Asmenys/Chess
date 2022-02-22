# frozen_string_literal: true

module Path_utilities
  def path_nodes_to_path(array_of_path_nodes)
    Path.new(array_of_path_nodes)
  end

  def paths_to_location_indexes(array_of_paths)
    node_index_array = []
    array_of_paths.each do |path|
      node_index_array += path.nodes_as_indexes
    end
    node_index_array
  end

  def paths_until_first_piece_from_path_array(array_of_paths)
    paths_until_first_piece = []
    array_of_paths.each do |path|
      paths_until_first_piece << path.path_until_first_piece
    end
    paths_until_first_piece
  end

  def remove_paths_that_dont_end_with_a_piece(array_of_paths)
    array_of_paths.delete_if { |path| path.last_node.value.nil? }
  end

  def filter_paths(array_of_paths)
    array_of_paths.keep_if(&:valid?)
    array_of_paths.delete_if(&:empty?)
    array_of_paths
  end

  def delete_empty_paths_from_array(array_of_paths)
    array_of_paths.delete_if(&:empty?)
  end

  def delete_empty_node_indexes(array_of_path_node_indexes)
    array_of_path_node_indexes.delete_if(&:empty?)
  end

  def delete_invalid_paths(array_of_path_node_indexes)
    array_of_path_node_indexes.delete_if { |path| path.any? { |index| valid_location?(index) == false } }
  end

  def valid_location?(location)
    result = false
    result = true if location[0] >= 0 && location[0] <= 7 && location[1] >= 0 && location[1] <= 7
    result
  end
end
