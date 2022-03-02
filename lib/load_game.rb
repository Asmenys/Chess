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
    full_turn = fen_notation_array[4].to_i
    half_turn = fen_notation_array[5].to_i
    en_passant_cords = en_passant_to_coordinates(en_passant)
    movement_manager = Movement.new(board, active_color, en_passant_cords)
    @game = Game.new(@board, movement_manager,
                     full_turn,
                     half_turn)
  end

  def split_fen_into_array(fen_string)
    fen_string.split(' ')
  end

  def en_passant_to_coordinates(en_passant)
    unless en_passant == '-'
      row = (en_passant[1].to_i - 8).abs
      column = en_passant[0].ord - 97
      [row, column]
    end
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
    piece = create_piece(name_to_color(name), name_to_piece(name))
    piece.moved if has_piece_moved?(piece, location)
    @board.set_square_to(location, piece)
  end

  def create_piece(colour, type)
    Object.const_get(type).new(colour, type)
  end

  def has_piece_moved?(piece, location)
    result = false
    case piece.name
    when 'Pawn'
      result = has_pawn_moved?(piece, location)
    when 'Rook'
      result = has_rook_moved?(piece, location)
    when 'King'
      result = has_king_moved?(piece, location)
    end
    result
  end

  def has_pawn_moved?(piece, location)
    row = location[0]
    color = piece.team
    row != if color == 'black'
             1
           else
             6
           end
  end

  def has_rook_moved?(piece, location)
    color = piece.team
    starting_locations = if color == 'black'
                           [[0, 0], [0, 7]]
                         else
                           [[7, 0], [7, 7]]
                         end
    starting_locations.none? { |location_index| location_index == location }
  end

  def has_king_moved?(piece, location)
    color = piece.team
    location != if color == 'black'
                  [0, 4]
                else
                  [7, 4]
                end
  end

  def name_to_color(name)
    if name.is_upper?
      'white'
    else
      'black'
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
