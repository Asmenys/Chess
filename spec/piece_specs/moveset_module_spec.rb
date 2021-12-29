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
