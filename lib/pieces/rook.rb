class Rook < Piece
  include Horizontal_moveset
  def possible_moves(location)
    move_array = [moves_on_axis(location, 0), moves_on_axis(location, 1)]
  end

  def castling(kings_location, kings_move_direction)
    [kings_location[0], kings_location[1] - (1 * kings_move_direction)]
  end
end
