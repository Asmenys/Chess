# frozen_string_literal: true

class Pawn < Piece
  def possible_paths(_current_location)
    []
  end

  def possible_attack_paths(current_location)
    capture_nodes(current_location)
  end

  def capture_nodes(current_location)
    [
      [current_location[0] + get_vertical_movement_index, current_location[1] + 1],
      [current_location[0] + get_vertical_movement_index, current_location[1] - 1]
    ]
  end

  def one_step(location)
    [[increment_y_axis(location[0]), location[1]]]
  end

  def two_step(location)
    unless @has_moved
      [
        [increment_y_axis(location[0]), location[1]],
        [increment_y_axis(increment_y_axis(location[0])), location[1]]
      ]
    end
  end

  def en_passant_location(location)
    one_step(location).first
  end

  def increment_y_axis(point)
    point + (1 * get_vertical_movement_index)
  end

  def get_vertical_movement_index
    if @team == 'black'
      1
    else
      -1
    end
  end
end
