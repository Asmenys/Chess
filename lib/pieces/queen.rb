
class Queen < Piece
    include Horizontal_moveset
    include Diagonal_moveset
  
    def possible_moves(location)
      move_array = [diagonal_movement(location, 1, 1),
                    diagonal_movement(location, -1, -1),
                    moves_on_axis(location, 0),
                    moves_on_axis(location, 1)]
    end
  end