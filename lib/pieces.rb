# frozen_string_literal: true

require_relative 'piece_values'

class Piece
  attr_reader :team, :display_value, :has_moved

  def initialize(team_colour, piece_name)
    @team = team_colour
    @display_value = PIECE_DISPLAY_VALUES[@team.to_sym][piece_name.to_sym]
    @has_moved = false
  end

  def moved
    @has_moved = true
  end
end

class King < Piece
  def possible_moves(location)
    move_array = [basic_one_steps(location)]
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
end

class Queen < Piece
end

class Rook < Piece
  def possible_moves(location)
    possible_moves = [moves_on_axis(location, 0), moves_on_axis(location, 1)]
  end

  def moves_on_axis(location, movement_index)
    current_location = location[movement_index]
    temp_index = 0
    possible_moves = []
    while temp_index <= 7
      if temp_index == current_location
        temp_index += 1
      else
        location[movement_index] = temp_index
        possible_moves << [location[0], location[1]]
        temp_index += 1
      end
    end
    possible_moves
  end
end

class Bishop < Piece
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
  def two_step(location)
    if @has_moved == false
      if @team == 'black'
        [location[0] + 2, location[1]]
      else
        [location[0] - 2, location[1]]
      end
    end
  end

  def basic_one_step(location)
    if @team == 'black'
      [location[0] + 1, location[1]]
    else
      [location[0] - 1, location[1]]
    end
  end

  def possible_moves(location)
    move_array = [two_step(location), basic_one_step(location)]
  end
end
