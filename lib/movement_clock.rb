# frozen_string_literal: true

class Movement_clock
  attr_reader :full_turns, :half_turns

  def initialize(full_turns = 1, half_turns = 0)
    @full_turns = full_turns
    @half_turns = half_turns
  end

  def self_to_fen
    fen_string = "#{@half_turns} "
    fen_string += @full_turns.to_s
  end

  def increment_full_turns
    @full_turns += 1
  end

  def increment_half_turns
    @half_turns += 1
  end

  def reset_half_turns
    @half_turns = 0
  end

  def fifty_move_rule?
    @half_turns >= 50
  end
end
