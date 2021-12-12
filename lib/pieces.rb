# frozen_string_literal: true

require_relative 'piece_values'

class Piece
  attr_reader :team, :display_value

  def initialize(team_colour, piece_name)
    @team = team_colour
    @display_value = PIECE_DISPLAY_VALUES[@team.to_sym][piece_name.to_sym]
  end
end

class King < Piece
end

class Queen < Piece
end

class Rook < Piece
end

class Bishop < Piece
end

class Knight < Piece
end

class Pawn < Piece
end
