require_relative '../../lib/pieces/piece_class.rb'

describe King do
    describe '#castling' do
      subject(:king) { described_class.new('black', 'King') }
      context 'it moves the king 2 steps to the side' do
        it 'when castling is not avaialbe' do
          current_location = [4, 3]
          castling_availability = nil
          expect(king.castling(castling_availability, current_location)).to be nil
        end
        it 'when castling is available' do
          current_location = [8, 3]
          castling_availability = 1
          expected_final_location = [8, 5]
          expect(king.castling(castling_availability, current_location)).to eq(expected_final_location)
        end
      end
    end
  end