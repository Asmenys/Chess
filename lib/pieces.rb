# frozen_string_literal: true

require_relative 'piece_values'

class Piece
  attr_reader :team, :display_value, :has_moved

  def initialize(team_colour, piece_name)
    @team = team_colour
    @display_value = PIECE_DISPLAY_VALUES[@team.to_sym][piece_name.to_sym]
    @has_moved = false
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
end

class Bishop < Piece
end

class Knight < Piece
  def basic_jumps(location)
    [
      [location[0]+1, location[1]+2],
      [location[0]+1, location[1]-2],
      [location[0]+2, location[1]+1],
      [location[0]+2, location[1]-1],
      [location[0]-2, location[1]-1],
      [location[0]-2, location[1]+1],
      [location[0]-1, location[1]+2],
      [location[0]-1, location[1]-2]
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
        [location[0]+2, location[1]]
      else
        [location[0]-2, location[1]]
      end
    end
  end
  
  def basic_one_step(location)
    if @team == 'black'
      [location[0]+1, location[1]]
    else
      [location[0]-1, location[1]]
    end
  end

  def possible_moves(location)
    move_array = [two_step(location), basic_one_step(location)]
  end
end
