# frozen_string_literal: true

class Move_logger
  def initialize(active_color_clock, last_move_black = nil, last_move_white = nil, movement_repetitions = 0)
    @active_color_clock = active_color_clock
    @last_move_white = last_move_white
    @last_move_black = last_move_black
    @movement_repetitions = movement_repetitions
  end

  def log_movement(movement_direction)
    update_repetitions(movement_direction)
    update_last_move(movement_direction)
  end

  def update_repetitions(movement_direction)
    movement_destination = movement_direction.destination
    if repetetive_movement?(movement_destination)
      @move_repetitions += 1
    else
      @move_repetitions = 0
    end
  end

  def repetetive_movement?(movement_destination)
    case @active_color_clock.fen_to_color
    when 'black'
      begin
        movement_destination == @last_move_black
      rescue StandardError
        false
      end
    when 'white'
      begin
        movement_destination == @last_move_white
      rescue StandardError
        false
      end
    end
  end

  def update_last_move(movement_direction)
    if @active_color_clock.fen_to_color == 'black'
      @last_move_black = movement_direction.current_location
    else
      @last_move_white = movement_direction.current_location
    end
  end
end
