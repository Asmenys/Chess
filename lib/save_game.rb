# frozen_string_literal: true

class Save_game
  def initialize(game_instance)
    @game = game_instance
  end

  def save_game
    create_save_dir unless does_save_dir_exist?
    File.open("saves/#{get_file_name}", 'w') { |save_file| save_file.write @game.self_to_fen }
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
end
