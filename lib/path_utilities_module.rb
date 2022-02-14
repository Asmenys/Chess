# frozen_string_literal: true

module Path_utilities
  def path_nodes_to_path(array_of_path_nodes)
    Path.new(array_of_path_nodes)
  end

  def filter_paths(array_of_paths)
    array_of_paths.keep_if(&:valid?)
    array_of_paths.delete_if(&:empty?)
    array_of_paths
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
