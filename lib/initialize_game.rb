# frozen_string_literal: true

require_relative 'pieces/piece_class'
require_relative 'board'
require_relative 'communication_module'

class Board_populater
  include Communication

  def initialize
    @board = Board.new
  end

  def return_populated_board
    populate_the_board
    @board
  end

  def populate_the_board
    populate_the_knights
    populate_the_pawns
    populate_the_rooks
    populate_the_bishops
    populate_the_queens
    populate_the_kings
  end

  def populate_the_knights
    @board.add_piece('white', 'Knight', notation_to_location('g1'))
    @board.add_piece('white', 'Knight', notation_to_location('b1'))
    @board.add_piece('black', 'Knight', notation_to_location('b8'))
    @board.add_piece('black', 'Knight', notation_to_location('g8'))
  end

  def populate_the_pawns
    column_index = 97
    while column_index <= 104
      white_location = notation_to_location("#{column_index.chr}2")
      black_location = notation_to_location("#{column_index.chr}7")
      @board.add_piece('white', 'Pawn', white_location)
      @board.add_piece('black', 'Pawn', black_location)
      column_index += 1
    end
  end

  def populate_the_rooks
    @board.add_piece('white', 'Rook', notation_to_location('a1'))
    @board.add_piece('white', 'Rook', notation_to_location('h1'))
    @board.add_piece('black', 'Rook', notation_to_location('a8'))
    @board.add_piece('black', 'Rook', notation_to_location('h8'))
  end

  def populate_the_bishops
    @board.add_piece('white', 'Bishop', notation_to_location('c1'))
    @board.add_piece('white', 'Bishop', notation_to_location('f1'))
    @board.add_piece('black', 'Bishop', notation_to_location('c8'))
    @board.add_piece('black', 'Bishop', notation_to_location('f8'))
  end

  def populate_the_queens
    @board.add_piece('black', 'Queen', notation_to_location('e8'))
    @board.add_piece('white', 'Queen', notation_to_location('e1'))
  end

  def populate_the_kings
    @board.add_piece('black', 'King', notation_to_location('d8'))
    @board.add_piece('white', 'King', notation_to_location('d1'))
    @board.black_king_location = notation_to_location('d8')
    @board.white_king_location = notation_to_location('d1')
  end
end
