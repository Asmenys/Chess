# frozen_string_literal: true

class Pawn < Piece
  include Vertical_moveset

  def two_step(current_location)
    unless @has_moved
      final_location = [get_final_y_point(current_location[0], 2), current_location[1]]
      generate_vertical_movements(current_location, final_location)
    end
  end

  def one_step(location)
    [[get_final_y_point(location[0], 1), location[1]]]
  end
end
