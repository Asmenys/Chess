# frozen_string_literal: true

class Bishop < Piece
  include Diagonal_moveset
  def possible_moves(location)
    move_array = [diagonal_movement(location, 1, 1),
                  diagonal_movement(location, -1, -1)]
  end
end
