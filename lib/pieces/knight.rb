# frozen_string_literal: true

class Knight < Piece
  include Knight_moveset
  def possible_paths(location)
    move_array = basic_jumps(location)
  end

  def basic_jumps(location)
    get_knight_movements(location)
  end
end
