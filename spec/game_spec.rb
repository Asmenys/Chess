# frozen_string_literal: true

require 'game'
require 'load_game'

describe Game do
  subject(:default_game) { Load_game.new.game }
  describe '#get_valid_piece_selection' do
    context 'upon call prompts for an input and returns it if the input is valid' do
      invalid_input = '43'
      invalid_input_two = 'hahaha'
      valid_input = 'a7'
      it 'upon giving a single invalid input and a single valid input returns the valid input' do
        allow(default_game).to receive(:get_piece_selection).and_return(invalid_input, valid_input)
        expect(default_game.get_valid_piece_selection).to eq valid_input
      end
      it 'upon giving two invalid inputs and one valid returns the valid input' do
        allow(default_game).to receive(:get_piece_selection).and_return(invalid_input, invalid_input, valid_input)
        expect(default_game.get_valid_piece_selection).to eq valid_input
      end
    end
  end
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
  describe 'valid_piece_selection?' do
    context 'given a string returns whether its a valid selection or not' do
      invalid_selection = 'b9'
      valid_selection = 'e4'
      game = Load_game.new('8/8/8/4P3/8/8/8/8 w - - 0 1').game
      it 'when given an invalid selection returns false' do
        expect(game.valid_piece_selection?(invalid_selection)).to be false
      end
      it 'when given a valid selection returns true' do
        expect(game.valid_piece_selection?(valid_selection)).to be true
      end
    end
  end
  describe '#is_notation?' do
    context 'returns true or false based on given string input' do
      is_not_notation = '43'
      is_notation = 'e4'
      it 'when given an input that is not board notation returns false' do
        expect(default_game.is_notation?(is_not_notation)).to be false
      end
      it 'given an input that is board notation returns true' do
        expect(default_game.is_notation?(is_notation)).to be true
      end
    end
  end
  describe '#selection_to_location' do
    it 'converts e4 to [3, 4]' do
      expect(default_game.selection_to_location('e4')).to eq [3, 4]
    end
    it 'converts g2 to [1, 6]' do
      expect(default_game.selection_to_location('g2')).to eq [1, 6]
    end
  end
end
