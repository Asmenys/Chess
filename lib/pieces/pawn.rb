# frozen_string_literal: true

class Pawn < Piece
  def possible_paths(current_location)
    if @has_moved
      [one_step(current_location)]
    else
      [two_step(current_location)]
    end
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
