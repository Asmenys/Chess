# frozen_string_literal: true

require 'game'

describe Queen do
  subject(:queen) { described_class.new('black', 'Queen') }
  describe '#possible_paths' do
    it 'returns all possible paths that a queen may take from her current position' do
      current_location = [4, 3]
      expected_array_result = [[[5, 3], [6, 3], [7, 3]],
                               [[3, 3], [2, 3], [1, 3], [0, 3]],
                               [[4, 2], [4, 1], [4, 0]],
                               [[4, 4], [4, 5], [4, 6], [4, 7]],
                               [[5, 2], [6, 1], [7, 0]],
                               [[5, 4], [6, 5], [7, 6]],
                               [[3, 2], [2, 1], [1, 0]],
                               [[3, 4], [2, 5], [1, 6], [0, 7]]]
      expect(queen.possible_paths(current_location)).to eq(expected_array_result)
    end
  end
end
