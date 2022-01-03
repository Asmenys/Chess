# frozen_string_literal: true

require 'game'

describe Diagonal_moveset do
  subject(:bishop_black) { Bishop.new('black', 'Bishop') }
  context 'diagonal moveset function tests' do
    describe '#modify_dimension' do
      subject(:bishop) { described_class.new('black', 'Bishop') }
      context 'it increments/decrements the given dimension while keeping it within bounds' do
        it 'decrements the dimension' do
          dimensino = 4
          expected_array_result = [3, 2, 1, 0]
          expect(bishop_black.modify_dimension(dimensino, -1)).to eq(expected_array_result)
        end
        it 'increments the dimension' do
          dimensino = 4
          expected_array_result = [5, 6, 7]
          expect(bishop_black.modify_dimension(dimensino, 1)).to eq(expected_array_result)
        end
      end
    end
    describe '#diagonal_movement' do
      subject(:bishop) { described_class.new('black', 'Bishop') }
      context 'it generates an array of movements along a diagonal left/right' do
        it 'generates diagonal movements up to left' do
          location = [4, 3]
          expected_array_result = [[[3, 2], [2, 1], [1, 0]], [[5, 4], [6, 5], [7, 6]]]
          result_array = [bishop_black.diagonal_movement_end_points(location, -1, -1),
                          bishop_black.diagonal_movement_end_points(location, 1, 1)]
          expect(expected_array_result).to eq(result_array)
        end
        it 'generates diagonal movements up to right' do
          location = [4, 3]
          expected_array_result = [[[3, 4], [2, 5], [1, 6], [0, 7]], [[5, 2], [6, 1], [7, 0]]]
          result_array = [bishop_black.diagonal_movement_end_points(location, 1, -1),
                          bishop_black.diagonal_movement_end_points(location, -1, 1)]
        end
      end
    end
  end
end
