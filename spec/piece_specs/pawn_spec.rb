require_relative '../../lib/pieces/piece_class.rb'
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