# frozen_string_literal: true

require 'game'

describe Rook do
  subject(:rook) { described_class.new('black', 'Rook') }
  describe '#possible_paths' do
    it 'returns all possible paths a rook may take from his current position' do
      starting_location = [4, 3]
      expected_array_result = [[[5, 3], [6, 3], [7, 3]],
                               [[3, 3], [2, 3], [1, 3], [0, 3]],
                               [[4, 2], [4, 1], [4, 0]],
                               [[4, 4], [4, 5], [4, 6], [4, 7]]]
      expect(rook.possible_paths(starting_location)).to eq(expected_array_result)
    end
  end
end
