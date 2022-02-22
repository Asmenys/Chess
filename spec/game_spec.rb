# frozen_string_literal: true

require 'game'
require 'load_game'

describe Game do
  describe '#no_legal_movements_left?' do
    context 'when called, gets all pieces of color equivalent to the current fen state and returns a bool whether or not any of them can make a movement' do
      game_without_movements = Load_game.new('r1bqkb1r/pppp1Q1p/2n5/4N1p1/4n3/2N5/PPPP1PPP/R1B1KB1R b KQkq - 0 6').game
      game_with_movements = Load_game.new('r1bqkb1r/pppp1ppp/2n2n2/4N3/4P3/2N5/PPPP1PPP/R1BQKB1R b KQkq - 0 4').game
      it 'when there are no legal movements to be made, returns true' do
        expect(game_without_movements.no_legal_movements_left?).to be true
      end
      it 'when there are legal movements to be made, returns false' do
        expect(game_with_movements.no_legal_movements_left?).to be false
      end
    end
  end
end
