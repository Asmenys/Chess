require 'pieces.rb'

    describe Pawn do
        describe '#two_step' do
        subject(:pawn) {described_class.new("black", "pawn")}
            context 'if the piece has not yet been moved, it can two step' do
                it 'returns the would-be location when given its current location' do
                    current_location = [4,3]
                    expected_location = [6,3]
                    expect(pawn.two_step(current_location)).to eq(expected_location)
                end
            end
        end
    end


