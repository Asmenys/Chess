# frozen_string_literal: true

require_relative 'display/display'
require_relative 'display/string'
require_relative 'initialize_game'
require_relative 'communication_module'
class Game
  include Communication
  def initialize(_board = Board.new)
    @board = Board_populater.new.return_populated_board
  end

  def show_board
    @board.display_board
  end
end
