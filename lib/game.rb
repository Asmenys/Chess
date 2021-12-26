# frozen_string_literal: true

require_relative 'display/display'
require_relative 'display/string'
require_relative 'initialize_game.rb'

class Game
  def initialize(board = Board.new)
    @board = Board_populater.return_populated_board
  end

  def show_board
    @board.display_board
  end

  def notation_to_location(notation)
    [notation[1].to_i - 1, notation[0].ord - 97]
  end
end
