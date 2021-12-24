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

require_relative 'piece_values'
require_relative 'moveset_modules'
require_relative 'rook'
require_relative 'pawn'
require_relative 'king'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
