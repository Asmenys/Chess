# frozen_string_literal: true

require_relative '../../lib/pieces/piece_class'

describe King do
  describe '#possible_paths' do
    subject(:king) { described_class.new('black', 'King') }
    it 'returns the paths of all possible moves' do
      current_location = [4, 3]
      expected_result_array = [[[5, 3]], [[3, 3]], [[4, 4]], [[4, 2]], [[5, 4]], [[5, 2]], [[3, 2]], [[3, 4]]]
      expect(king.possible_paths(current_location)).to eq(expected_result_array)
    end
  end

  describe '#attack_paths' do
    subject(:king) { described_class.new('black', 'King') }
    context 'returns all the paths it could be attacked from' do
      it 'when approximately in the middle of the board returns all axis' do
        current_location = [4, 3]
        expected_array_result =
          [[[5, 3], [6, 3], [7, 3]],
           [[3, 3], [2, 3], [1, 3], [0, 3]],
           [[4, 2], [4, 1], [4, 0]],
           [[4, 4], [4, 5], [4, 6], [4, 7]],
           [[5, 2], [6, 1], [7, 0]],
           [[5, 4], [6, 5], [7, 6]],
           [[3, 2], [2, 1], [1, 0]],
           [[3, 4], [2, 5], [1, 6], [0, 7]],
           [[5, 5]],
           [[5, 1]],
           [[6, 4]],
           [[6, 2]],
           [[2, 2]],
           [[2, 4]],
           [[3, 5]],
           [[3, 1]]]
        expect(king.attack_paths(current_location)).to eq(expected_array_result)
      end
      it 'when at the corner of the board returns just the accessible axis' do
        current_location = [7, 0]
        expected_array_result = [[],
                                 [[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]],
                                 [],
                                 [[7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7]],
                                 [],
                                 [],
                                 [],
                                 [[6, 1], [5, 2], [4, 3], [3, 4], [2, 5], [1, 6], [0, 7]],
                                 [[8, 2]],
                                 [[8, -2]],
                                 [[9, 1]],
                                 [[9, -1]],
                                 [[5, -1]],
                                 [[5, 1]],
                                 [[6, 2]],
                                 [[6, -2]]]
        expect(king.attack_paths(current_location)).to eq(expected_array_result)
      end
      it 'when at the top of the board returns just the accesible axis' do
        current_location = [0, 4]
        expected_array_result = [[[1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4]],
                                 [],
                                 [[0, 3], [0, 2], [0, 1], [0, 0]],
                                 [[0, 5], [0, 6], [0, 7]],
                                 [[1, 3], [2, 2], [3, 1], [4, 0]],
                                 [[1, 5], [2, 6], [3, 7]],
                                 [],
                                 [],
                                 [[1, 6]],
                                 [[1, 2]],
                                 [[2, 5]],
                                 [[2, 3]],
                                 [[-2, 3]],
                                 [[-2, 5]],
                                 [[-1, 6]],
                                 [[-1, 2]]]
        expect(king.attack_paths(current_location)).to eq(expected_array_result)
      end
    end
  end
end
