# frozen_string_literal: true

require 'load_game'

describe Knight_moveset do
  subject(:test_subject) { Class.new { extend Knight_moveset } }
  describe '#get_knight_movements' do
    context 'returns locations of nodes a knight may jump to' do
      it 'returns all possible jumps from [4, 3]' do
        current_location = [4, 3]
        expected_location_array = [[[5, 5]], [[5, 1]], [[6, 4]], [[6, 2]], [[2, 2]], [[2, 4]], [[3, 5]], [[3, 1]]]
        expect(test_subject.get_knight_movements(current_location)).to eq expected_location_array
      end
      it 'returns all possible jumps, even technically illegal ones from [6, 8]' do
        current_location = [6, 8]
        expected_location_array = [[[7, 10]], [[7, 6]], [[8, 9]], [[8, 7]], [[4, 7]], [[4, 9]], [[5, 10]],
                                   [[5, 6]]]
        expect(test_subject.get_knight_movements(current_location)).to eq expected_location_array
      end
    end
  end
end
