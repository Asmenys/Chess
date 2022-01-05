# frozen_string_literal: true

class Queen < Piece
  include Horizontal_moveset
  include Diagonal_moveset

  def possible_paths(location)
    move_array = []
    move_array += moves_on_axis(location)
    move_array += diagonal_movement_paths(location)
  end
end
