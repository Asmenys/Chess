# frozen_string_literal: true

require 'pieces'

describe Pawn do
  describe '#two_step' do
    subject(:pawn) { described_class.new('black', 'pawn') }
    context 'if the piece has not yet been moved, it can two step' do
      it 'returns the would-be location when given its current location' do
        current_location = [4, 3]
        expected_location = [6, 3]
        expect(pawn.two_step(current_location)).to eq(expected_location)
      end
      it 'if the piece has been moved, should return nil' do
        current_location = [4, 3]
        pawn.moved
        expect(pawn.two_step(current_location)).to be nil
      end
    end
  end
end
describe Bishop do
  describe '#modify_dimension' do
    subject(:bishop) { described_class.new('black', 'bishop') }
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
    subject(:bishop) { described_class.new('black', 'bishop') }
    context 'it generates an array of movements along a diagonal left/right' do
      it 'generates diagonal movements up to left' do
        location = [4, 3]
        expected_array_result = [[7, 6], [6, 5], [5, 4], [3, 2], [2, 1], [1, 0]]
        expect(bishop.diagonal_movement(location, 1, 1)).to eq(expected_array_result)
      end
    end
  end
end
