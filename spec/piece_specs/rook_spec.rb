# frozen_string_literal: true

describe Rook do
  describe '#castling' do
    subject(:rook) { described_class.new('black', 'Rook') }
    context 'it moves the Rook to the other side of the King during castling' do
      it 'when king castles to the right side' do
        kings_new_location = [0, 5]
        kings_move_direction = 1
        expected_new_location = [0, 4]
        expect(rook.castling(kings_new_location, kings_move_direction)).to eq(expected_new_location)
      end
      it 'when king castles to the left side' do
        kings_new_location = [0, 5]
        kings_move_direction = -1
        expected_new_location = [0, 6]
        expect(rook.castling(kings_new_location, kings_move_direction)).to eq(expected_new_location)
      end
    end
  end
end
