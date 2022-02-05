# frozen_string_literal: true

require 'load_game'

describe King do
  describe '#possible_paths' do
    subject(:king) { described_class.new('black', 'King') }
    it 'returns the paths of all possible moves' do
      current_location = [4, 3]
      expected_result_array = [[[5, 3]], [[3, 3]], [[4, 4]], [[4, 2]], [[5, 4]], [[5, 2]], [[3, 2]], [[3, 4]]]
      expect(king.possible_paths(current_location)).to eq(expected_result_array)
    end
  end
end
