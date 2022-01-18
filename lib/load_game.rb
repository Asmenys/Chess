# frozen_string_literal: true

require_relative 'game'

class Load_game
  attr_reader :game, :board

  def initialize(fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0')
    setup_game_instance(fen_string)
  end

  def initialize_new_board
    @board = Board.new
  end

  def setup_game_instance(fen_string)
    fen_notation_array = split_fen_into_array(fen_string)
    initialize_new_board
    initialize_pieces(fen_notation_array[0])
    active_color = fen_notation_array[1]
    castling = fen_notation_array[2]
    en_passant = fen_notation_array[3]
    full_turn = fen_notation_array[4]
    half_turn = fen_notation_array[5]
    @game = Game.new(@board, active_color,
                     en_passant,
                     full_turn,
                     half_turn)
  end

  def split_fen_into_array(fen_string)
    fen_string.split(' ')
  end

  def initialize_pieces(piece_string)
    row = 0
    column = 0
    piece_string.each_char do |char|
      case true
      when is_type_of_piece?(char)
        initialize_piece(char, [row, column])
        column += 1
      when end_of_row?(char)
        row += 1
        column = 0
      when empty_square?(char)
        column += char.to_i
      end
    end
  end

  def empty_square?(char)
    /[1-8]/.match?(char)
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
