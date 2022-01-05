# frozen_string_literal: true

require_relative 'display/display'
require_relative 'display/string'
require_relative 'initialize_game'
require_relative 'communication_module'
class Game
  include Communication
  attr_reader :board

  def initialize(board = Board_populater.new.return_populated_board)
    @board = board
  end

  def show_board
    @board.display_board
  end

  def return_square_values_from(array)
    array.map do |square|
      square_value = @board.get_value_of_square(square)
      if square_value.nil?
        { index: square, piece_class: nil }
      else
        { index: square, piece_class: square_value.class }
      end
    end
  end

  def validate_path(array)
    valid_path_nodes = []
    end_of_path_reached = false
    array.each do |node|
      node_value = @board.get_value_of_square(node)
      valid_path_nodes << node
      if node_value.nil?
      else
        break
      end
    end
    valid_path_nodes
  end
end
