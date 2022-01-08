# frozen_string_literal: true

require_relative '../../lib/pieces/piece_class'

describe King do
  describe '#possible_moves' do
    subject(:king) { described_class.new('black', 'King') }
    it 'returns the paths of all possible moves' do
      current_location = [4, 3]
      expected_result_array = [[5, 3], [3, 3], [4, 4], [4, 2], [5, 4], [5, 2], [3, 2], [3, 4]]
      expect(king.possible_moves(current_location)).to eq(expected_result_array)
    end
  end

  describe '#attack_paths' do
    subject(:king) { described_class.new('black', 'King') }
    it 'returns all the paths it could be attacked from' do
      current_location = [4, 3]
      expected_array_result =
        [[[5, 3], [6, 3], [7, 3]],
         [[3, 3], [2, 3], [1, 3], [0, 3]],
         [[4, 2], [4, 1], [4, 0]],
         [[4, 4], [4, 5], [4, 6], [4, 7]],
         [[5, 2], [6, 1], [7, 0]],
         [[5, 4], [6, 5], [7, 6]],
         [[3, 2], [2, 1], [1, 0]],
         [[3, 4], [2, 5], [1, 6], [0, 7]]]
      expect(king.attack_paths(current_location)).to eq(expected_array_result)
    end
  end
end
