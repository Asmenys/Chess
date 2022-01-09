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

  def validate_array_of_paths(array)
    valid_paths = []
    array = filter_empty_paths(array)
    array.each do |path|
      valid_paths << validate_path(path)
    end
  end

  def validate_path(array)
    valid_path_nodes = []
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

  def filter_empty_paths(array)
    array.delete_if(&:empty?)
    array
  end
end
