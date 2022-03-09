# frozen_string_literal: true

class Command_directions
  attr_accessor :ends_the_game, :command_message

  def initialize(ends_the_game = false, command_message = nil)
    @ends_the_game = ends_the_game
    @command_message = command_message
  end
end
