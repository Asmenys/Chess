# frozen_string_literal: true

class Piece
  attr_reader :team, :display_value, :name
  attr_accessor :has_moved

  def initialize(team_colour, piece_name)
    @team = team_colour
    @display_value = PIECE_DISPLAY_VALUES[@team.to_sym][piece_name.to_sym]
    @name = piece_name
    @has_moved = false
  end

  def moved
    @has_moved = true
  end

  def reset_move
    @has_moved = false
  end

  def can_two_step?
    result = false
    result = true if !@has_moved && (@name == 'Pawn')
    result
  end

  def can_castle?
    result = false
    result = @has_moved == false if @name == 'Rook' || @name == 'King'
    result
  end

  def possible_attack_paths(current_location)
    possible_paths(current_location)
  end

  def self_to_fen
    case @team
    when 'black'
      @name.chars[0].downcase
    else
      @name.chars[0]
    end
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
