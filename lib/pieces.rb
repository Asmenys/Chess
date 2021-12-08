# frozen_string_literal: true

class Piece
  attr_reader :tema, :display_value

  def initialize(colour, name)
    @team = colour
    @display_value = PIECE_DISPLAY_VALUES[colour.to_sym][name.to_sym]
  end
end
