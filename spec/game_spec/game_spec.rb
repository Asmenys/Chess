# frozen_string_literal: true

require_relative '../../lib/game'

describe Game do
  describe '#return_square_values_from' do
    subject(:game) { described_class.new }
    context 'takes an array of board indexes and returns the values at given index on board' do
      it 'returns unmodified array when none of the indexes point to a value' do
        starting_array = [[4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7]]
        temp_index = -1
        expected_result_array = Array.new(8) { {index: [4, temp_index+=1], piece_class: nil}}
        expect(game.return_square_values_from(starting_array)).to eq(expected_result_array)
      end
      it 'when all indexes point to a pawn returns an array full of pawns' do
        starting_array = [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]]
        temp_index = -1
        expected_result_array = Array.new(8) { { index: [1, temp_index += 1], piece_class: Pawn } }
        expect(game.return_square_values_from(starting_array)).to eq(expected_result_array)
      end
    end
  end
end
