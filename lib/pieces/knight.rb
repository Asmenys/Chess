# frozen_string_literal: true

class Knight < Piece
  include Knight_moveset
  def possible_paths(location)
    move_array = basic_jumps(location)
  end

  def basic_jumps(location)
    get_knight_movements(location)
  end

  def self_to_fen
    case @team
    when 'black'
      'n'
    else
      'N'
    end
  end
end
