# frozen_string_literal: true

require 'pry-byebug'
require_relative 'fen_to_board'
require_relative 'game'

fen_instance = Fen_to_board.new(Board.new, 'rnbqkbnr/8/pppppppp')
fen_instance.initialize_pieces('rnbqkbnr/8/pppppppp')

bind
bind
bind
