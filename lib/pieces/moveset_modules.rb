# frozen_string_literal: true

module Diagonal_moveset
  def diagonal_movement_paths(location)
    end_points = []
    end_points << diagonal_movement_end_points(location, 1, -1)
    end_points << diagonal_movement_end_points(location, 1, 1)
    end_points << diagonal_movement_end_points(location, -1, -1)
    end_points << diagonal_movement_end_points(location, -1, 1)
  end

  def diagonal_movement_end_points(location, index_one, index_two)
    filter_the_array(generate_sub_array(location, index_one, index_two))
  end

  def generate_sub_array(location, index_one, index_two)
    row_modifications = modify_dimension(location[0], index_one)
    column_modifications = modify_dimension(location[1], index_two)
    result_array = conjoin_the_arrays(row_modifications, column_modifications)
  end

  def modify_dimension(dimension, index)
    array = []
    array << dimension += index while dimension >= 1 && dimension <= 6
    array
  end

  def filter_the_array(array)
    array.each do |sub_array|
      array.delete(sub_array) if sub_array.include?(nil)
    end
    array
  end

  def conjoin_the_arrays(row_array, column_array)
    conjoined_array = []
    row_array.each_with_index do |row, index|
      conjoined_array << [row, column_array[index]]
    end
    conjoined_array
  end
end

module Horizontal_moveset
  def moves_on_axis(location)
    [
      get_path_on_axis(location, 0, 1),
      get_path_on_axis(location, 0, -1),
      get_path_on_axis(location, 1, -1),
      get_path_on_axis(location, 1, 1)
    ]
  end

  def get_path_on_axis(location, movement_index, direction)
    current_location = [location[0], location[1]]
    temp_index = current_location[movement_index]
    path = []
    while temp_index <= 6 && temp_index >= 1
      temp_index += direction
      current_location[movement_index] = temp_index
      path << [current_location[0], current_location[1]]
    end
    path
  end
end

module Vertical_moveset
  def generate_vertical_movements(starting_point, finish_point)
    result_array = []
    unless starting_point == finish_point
      next_point = [increment_y_axis(starting_point[0]), starting_point[1]]
      result_array << next_point
      result_array += generate_vertical_movements(next_point, finish_point)
    end
    result_array
  end

  def increment_y_axis(point)
    point + (1 * get_vertical_movement_index)
  end

  def get_vertical_movement_index
    if @team == 'black'
      -1
    else
      1
    end
  end

  def get_final_y_point(current_y_point, mod_index)
    current_y_point + (get_vertical_movement_index * mod_index)
  end
end
