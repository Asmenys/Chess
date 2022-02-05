# frozen_string_literal: true

require 'load_game'

describe Bishop do
  subject(:bishop) { described_class.new('black', 'Bishop') }
  describe '#possible_paths' do
    it 'returns all the possible paths a piece may take from its current location' do
      starting_location = [4, 3]
      expected_array_result = [[[3, 2], [2, 1], [1, 0]],
                               [[5, 4], [6, 5], [7, 6]],
                               [[5, 2], [6, 1], [7, 0]],
                               [[3, 4], [2, 5], [1, 6], [0, 7]]]
      expect(bishop.possible_paths(starting_location)).to eq(expected_array_result)
    end
  end
end
