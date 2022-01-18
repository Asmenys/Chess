# frozen_string_literal: true

module Path_validation
  def validate_array_of_paths(array)
    valid_paths = []
    array = clean_paths(array)
    array.each do |path|
      valid_paths << path_until_first_piece(path)
    end
  end

  def delete_invalid_paths(path_array)
    path_array.delete_if { |path| is_path_invalid?(path) }
    path_array
  end

  def clean_paths(paths)
    paths = filter_empty_paths(paths)
    delete_invalid_paths(paths)
  end

  def is_path_invalid?(path)
    result = false
    result = true if path.any? { |node| valid_dimensions?(node) == false }
    result
  end

  def filter_empty_paths(array)
    array.delete_if(&:empty?)
    array
  end
end
