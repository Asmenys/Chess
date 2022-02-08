# frozen_string_literal: true

require 'game'
require 'load_game'

describe Game do
  describe '#would_leave_king_in_check?' do
    context 'returns a bool based on whether the move leaves own players king in check' do
      xit 'when a pawn moves leaving the king in check for a bishop return true' do
        game = Load_game.new('8/8/8/4b3/3P4/2K5/8/8 w - - 0 1').game
        current_loc = [4, 3]
        destination_loc = [3, 3]
        expect(game.would_leave_king_in_check?(current_loc, destination_loc)).to be true
      end
      xit 'when a pawn moves but the king is not left in check for a bishop' do
        game = Load_game.new('8/8/8/4b3/8/2KP4/8/8 w - - 0 1').game
        current_loc = [5, 3]
        destination_loc = [4, 3]
        expect(game.would_leave_king_in_check?(current_loc, destination_loc)).to be false
      end
    end
  end
end
