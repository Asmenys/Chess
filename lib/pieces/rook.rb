# frozen_string_literal: true

class Rook < Piece
  include Horizontal_moveset
  def possible_moves(location)
    move_array = moves_on_axis(location)
  end

  def castling(kings_location, kings_move_direction)
    [kings_location[0], kings_location[1] - (1 * kings_move_direction)]
  end
end
