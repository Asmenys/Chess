# frozen_string_literal: true

require_relative 'communication_module'
require_relative 'pieces/piece_class'
class Fen_to_board
  include Communication
  attr_reader :board

  def initialize(fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR', board = Board.new)
    @fen_instance = fen_string
    @board = board
    initialize_pieces
  end

  def initialize_pieces(fen_string = @fen_instance)
    row = 0
    column = 0
    fen_string.each_char do |char|
      case true
      when is_type_of_piece?(char)
        initialize_piece(char, [row, column])
        column += 1
      when end_of_row?(char)
        row += 1
        column = 0
      when empty_square?(char)
        column += char.to_i
      when end_of_sequence?(char)
        break
      end
    end
  end

  def end_of_sequence?(char)
    char == ' '
  end

  def empty_square?(char)
    !/[1-9]/.match(char).nil?
  end

  def end_of_row?(char)
    char == '/'
  end

  def is_type_of_piece?(char)
    !name_to_piece(char).nil?
  end

  def initialize_piece(name, location)
    @board.add_piece(name_to_color(name), name_to_piece(name), location)
  end

  def name_to_color(name)
    if name.is_upper?
      'black'
    else
      'white'
    end
  end

  def name_to_piece(name)
    name = name.downcase
    type_hash = {
      'King' => 'k',
      'Queen' => 'q',
      'Bishop' => 'b',
      'Rook' => 'r',
      'Knight' => 'n',
      'Pawn' => 'p'
    }
    type_hash.key(name)
  end
end
