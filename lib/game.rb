# frozen_string_literal: true

require_relative 'display/display'
require_relative 'display/string'
require_relative 'fen_to_board'
require_relative 'communication_module'
require_relative 'board'
class Game
  include Communication
  attr_reader :board

  def initialize(board = Fen_to_board.new.board)
    @board = board
  end

  def show_board
    @board.display_board
  end

  def get_earliest_piece_with_location(path)
    piece = nil
    location = nil
    piece_found = false
    path.each do |node|
      node_value = @board.get_value_of_square(node)
      next if node_value.nil?

      piece = node_value
      location = node
      piece_found = true
      break
    end
    [piece, location] if piece_found
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
