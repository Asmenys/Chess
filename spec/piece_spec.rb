# frozen_string_literal: true

require 'game'

describe Pawn do
  describe '#basic_one_step' do
    subject(:pawn) { described_class.new('black', 'Pawn') }
    it 'advances the piece one step forward' do
      starting_location = [4, 3]
      expected_finish_location = [5, 3]
      expect(pawn.basic_one_step(starting_location)).to eq(expected_finish_location)
    end
  end
  describe '#two_step' do
    subject(:pawn) { described_class.new('black', 'Pawn') }
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
  describe 'en_passant' do
    subject(:pawn) { described_class.new('black', 'Pawn') }
    context 'returns the final location of the piece after performing an en passant move' do
      it 'when en passant is not available returns nil' do
        current_location = [4, 3]
        expect(pawn.en_passant(current_location, nil)).to be nil
      end
      it 'when en passant is viable returns it final location' do
        current_location = [4, 3]
        expected_final_location = [5, 4]
        expect(pawn.en_passant(current_location, 1)).to eq(expected_final_location)
      end
    end
  end
end
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
