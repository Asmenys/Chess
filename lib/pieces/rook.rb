# frozen_string_literal: true

class Rook < Piece
  include Horizontal_moveset
  def possible_paths(location)
    move_array = moves_on_axis(location)
  end
end
