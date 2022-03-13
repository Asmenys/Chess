# frozen_string_literal: true

module Piece_creation
  def create_piece(colour, type)
    Object.const_get(type).new(colour, type)
  end
end
