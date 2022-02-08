# frozen_string_literal: true

require_relative 'display/display'
require_relative 'display/string'
require_relative 'pieces/piece_class'
require_relative 'self_check'
require_relative 'path'
require_relative 'node'
require_relative 'board'
require_relative 'movement_class'

class Game
  attr_reader :full_turns, :half_turn, :en_passant, :active_color, :movement
  attr_accessor :board

  def initialize(board, movement_manager, full_turn = nil, half_turn = nil)
    @board = board
    @full_turns = full_turn
    @half_turn = half_turn
    @en_passant = en_passant
    @active_color = active_color
    @self_check = Self_check.new(self)
    @movement = movement_manager
  end

  def would_leave_king_in_check?(current_location, movement_destination)
    @self_check.self_check?(current_location, movement_destination)
  end
end
