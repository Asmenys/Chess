# frozen_string_literal: true

require_relative '../../lib/pieces/piece_class'
describe Bishop do
  describe '#modify_dimension' do
    subject(:bishop) { described_class.new('black', 'Bishop') }
    context 'it increments/decrements the given dimension while keeping it within bounds' do
      it 'decrements the dimension' do
        dimensino = 4
        expected_array_result = [3, 2, 1, 0]
        expect(bishop.modify_dimension(dimensino, -1)).to eq(expected_array_result)
      end
      it 'increments the dimension' do
        dimensino = 4
        expected_array_result = [5, 6, 7]
        expect(bishop.modify_dimension(dimensino, 1)).to eq(expected_array_result)
      end
    end
  end
  describe '#diagonal_movement' do
    subject(:bishop) { described_class.new('black', 'Bishop') }
    context 'it generates an array of movements along a diagonal left/right' do
      it 'generates diagonal movements up to left' do
        location = [4, 3]
        expected_array_result = [[7, 6], [6, 5], [5, 4], [3, 2], [2, 1], [1, 0]]
        expect(bishop.diagonal_movement(location, 1, 1)).to eq(expected_array_result)
      end
      it 'generates diagonal movements up to right' do
        location = [3, 4]
        expected_array_result = [[0, 1], [1, 2], [2, 3], [4, 5], [5, 6], [6, 7]]
        expect(bishop.diagonal_movement(location, -1, -1)).to eq(expected_array_result)
      end
    end
  end
end
