# frozen_string_literal: true

class Bishop < Piece
  include Diagonal_moveset
  def possible_paths(location)
    [diagonal_movement_end_points(location, -1, -1), diagonal_movement_end_points(location, 1, 1),
     diagonal_movement_end_points(location, 1, -1), diagonal_movement_end_points(location, -1, 1)]
  end
end
