# frozen_string_literal: true

require 'game'

describe Vertical_moveset do
  let(:pawn_black) { Pawn.new('black', 'Pawn') }
  let(:pawn_white) { Pawn.new('white', 'Pawn') }
  context 'movement_module tests using a pawn' do
    describe '#get_vertical_movement_index' do
      it 'returns 1 for white pawn' do
        expect(pawn_white.get_vertical_movement_index).to be 1
      end
      it 'returns -1 for black pawn' do
        expect(pawn_black.get_vertical_movement_index).to be(-1)
      end
    end
    describe '#increment_y_axis' do
      it 'increments the given value for white pieces' do
        expect(pawn_white.increment_y_axis(1)).to be 2
      end
      it 'decrements the value for black pieces' do
        expect(pawn_black.increment_y_axis(1)).to be 0
      end
    end
    describe 'generate_vertical_movements' do
      describe 'returns the path a piece would have to along the vertical axis' do
        it 'moves down to up for black pieces' do
          starting_point = [4, 3]
          finish_point = [1, 3]
          expected_result_array = [[3, 3], [2, 3], [1, 3]]
          expect(pawn_black.generate_vertical_movements(starting_point,
                                                        finish_point)).to eq(expected_result_array)
        end
      end
    end
  end
end

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
