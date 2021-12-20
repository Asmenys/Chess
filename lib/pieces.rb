# frozen_string_literal: true

class Piece
  attr_reader :team, :display_value, :has_moved, :name

  def initialize(team_colour, piece_name)
    @team = team_colour
    @display_value = PIECE_DISPLAY_VALUES[@team.to_sym][piece_name.to_sym]
    @has_moved = false
    @name = piece_name
  end

  def moved
    @has_moved = true
  end
end

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

class Rook < Piece
  include Horizontal_moveset
  def possible_moves(location)
    move_array = [moves_on_axis(location, 0), moves_on_axis(location, 1)]
  end

  def castling(kings_location, kings_move_direction)
    [kings_location[0], kings_location[1] - (1 * kings_move_direction)]
  end
end

class Bishop < Piece
  include Diagonal_moveset
  def possible_moves(location)
    move_array = [diagonal_movement(location, 1, 1),
                  diagonal_movement(location, -1, -1)]
  end
end

class Knight < Piece
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

  def possible_moves(location)
    move_array = [basic_jumps(location)]
  end
end

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
