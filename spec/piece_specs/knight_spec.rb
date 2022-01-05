# frozen_string_literal: true

describe Knight do
  subject(:knight) { described_class.new('black', 'knight') }
  describe '#possible_paths'
  it 'returns all the possible paths a piece may take' do
    current_location = [4, 3]
    expected_location_array = [[[5, 5]], [[5, 1]], [[6, 4]], [[6, 2]], [[2, 2]], [[2, 4]], [[3, 5]], [[3, 1]]]
    expect(knight.possible_paths(current_location)).to eq(expected_location_array)
  end
end
