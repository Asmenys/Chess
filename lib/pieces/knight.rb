# frozen_string_literal: true

class Knight < Piece
  def possible_moves(location)
    move_array = [basic_jumps(location)]
  end

  def basic_jumps(location)
    [
      [location[0] + 1, location[1] + 2],
      [location[0] + 1, location[1] - 2],
      [location[0] + 2, location[1] + 1],
      [location[0] + 2, location[1] - 1],
      [location[0] - 2, location[1] - 1],
      [location[0] - 2, location[1] + 1],
      [location[0] - 1, location[1] + 2],
      [location[0] - 1, location[1] - 2]
    ]
  end
end
