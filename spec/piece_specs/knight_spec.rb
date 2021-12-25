# frozen_string_literal: true

describe Knight do
  subject(:knight) { described_class.new('black', 'knight') }
  context 'movement tests' do
    it 'jumps to squares around it' do
      current_location = [4, 3]
      expected_location_array = [[5, 5], [5, 1], [6, 4], [6, 2], [2, 2], [2, 4], [3, 5], [3, 1]]
      expect(knight.basic_jumps(current_location)).to eq(expected_location_array)
    end
  end
end
