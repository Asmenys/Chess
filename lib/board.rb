# frozen_string_literal: true

class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
  end
end
