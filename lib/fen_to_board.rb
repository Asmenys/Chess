# frozen_string_literal: true

require_relative 'pieces/piece_class'
require_relative 'board'
require_relative 'communication_module'

class Fen_to_board
  include Communication

  def initialize(board, fen_string)
    @fen_instance = fen_string
    @board = board
  end

  def initialize_piece(name, location)
    @board.add_piece(name_to_color(name), name_to_piece(name), location)
  end

  def name_to_color(name)
    if name.is_upper?
      "black"
    else
      "white"
    end
  end

  def name_to_piece(name)
    name = name.downcase
    type_hash = {
      "King" => "k",
      "Queen" => "q",
      "Bishop" => "b",
      "Rook" => "r",
      "Knight" => "n",
      "Pawn" => "p"
    }
    type_hash.key(name)
  end
  
end
