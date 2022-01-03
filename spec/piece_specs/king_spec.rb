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
end
