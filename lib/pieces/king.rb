# frozen_string_literal: true

class King < Piece
  include Diagonal_moveset
  include Horizontal_moveset
  def possible_moves(location)
    possible_moves = []
    possible_moves += basic_one_steps(location)
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

  def attack_paths(location)
    paths = []
    paths += moves_on_axis(location)
    paths += diagonal_movement_paths(location)
  end
end
