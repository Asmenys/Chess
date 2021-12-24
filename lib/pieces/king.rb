# frozen_string_literal: true

class King < Piece
  def possible_moves(location, castling_viability)
    move_array = [basic_one_steps(location), castling(castling_viability)]
  end

  def basic_one_steps(location)
    [
      [location[0] + 1, location[1]],
      [location[0] - 1, location[1]],
      [location[0], location[1] + 1],
      [location[0], location[1] - 1],
      [location[0] + 1, location[1] + 1],
      [location[0] + 1, location[1] - 1],
      [location[0] - 1, location[1] - 1],
      [location[0] - 1, location[1] + 1]
    ]
  end

  def castling(castling_viability = nil, location)
    [location[0], location[1] + (2 * castling_viability)] unless castling_viability.nil?
  end
end
