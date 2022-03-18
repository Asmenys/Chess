# frozen_string_literal: true

class Command_interpreter
  def initialize(player, game_saver)
    @game_saver = game_saver
    @player = player
  end

  def execute_command(command)
    command_result_message = ''
    command_direction = Command_directions.new
    case command
    when 'save'
      @game_saver.save_game
      command_result_message = 'game has been saved'
    when 'draw'
      if @player.agrees_to_a_draw?
        command_direction.ends_the_game = true
        command_result_message = 'Players have agreed to a draw'
      end
    when 'resign'
      command_result_message = 'Player has resigned from the game'
      command_direction.ends_the_game = true
    when 'ls'
      command_result_message = 'save, resign, draw, ls'
    end
    command_direction.command_message = command_result_message
    command_direction
  end

  def is_a_command?(player_game_input)
    %w[save draw resign ls].include?(player_game_input.downcase)
  end
end
