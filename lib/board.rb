# frozen_string_literal: true

require_relative 'display'

class Board
  attr_reader :board

  include Display

  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def add_piece(team_colour, type); end
end
