# frozen_string_literal: true

class Pawn < Piece
  def possible_moves(location, _en_passant_viability = nil)
    move_array = [two_step(location), basic_one_step(location),
                  en_passant(location, en_passant_viable?)]
  end

  def vertical_move(location, change_value)
    if @team == 'black'
      location[0] + change_value
    else
      location[0] - change_value
    end
  end

  def two_step(location)
    [vertical_move(location, 2), location[1]] if @has_moved == false
  end

  def basic_one_step(location)
    [vertical_move(location, 1), location[1]]
  end

  def en_passant(location, en_passant_viability)
    [vertical_move(location, 1), location[1] + (1 * en_passant_viability)] unless en_passant_viability.nil?
  end
end
