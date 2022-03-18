# frozen_string_literal: true

class Command_interpreter
  def initialize(player)
    @player = player
  end
  def execute_command(command)
    command_result_message = ''
    command_direction = Command_directions.new
    case command
    when 'save'
      # save_game
      # command_result_message = 'game has been saved'
      # does not work yet, need to refactor into a save_game class
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

  def does_save_dir_exist?
    Dir.exist?('saves/')
  end

  def get_file_name
    "saved_game_#{get_file_name_index}"
  end

  def create_save_dir
    Dir.mkdir('saves/')
  end

  def get_file_name_index
    Dir.glob('saves/**').length.to_s
  end

  def is_a_command?(player_game_input)
    %w[save draw resign ls].include?(player_game_input.downcase)
  end
end
