# frozen_string_literal: true

require_relative 'load_game'
class Main
  @active_game = nil
  def load_game(fen_string)
    if fen_string.nil? || fen_string.empty?
      Load_game.new.game
    else
      Load_game.new(fen_string)
    end
  end
end
