# frozen_string_literal: true

class King < Piece
  def possible_paths(location)
    basic_one_steps(location)
  end

  def basic_one_steps(location)
    [
      [[location[0] + 1, location[1]]],
      [[location[0] - 1, location[1]]],
      [[location[0], location[1] + 1]],
      [[location[0], location[1] - 1]],
      [[location[0] + 1, location[1] + 1]],
      [[location[0] + 1, location[1] - 1]],
      [[location[0] - 1, location[1] - 1]],
      [[location[0] - 1, location[1] + 1]]
    ]
  end
end
