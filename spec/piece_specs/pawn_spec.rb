# frozen_string_literal: true

require 'game'
describe Pawn do
  let(:white_pawn) { described_class.new('white', 'Pawn') }
  let(:black_pawn) { described_class.new('black', 'Pawn') }
  describe '#two_step' do
    it 'decrements y axis for black pieces' do
      starting_location = [4, 4]
      expected_result_array = [[5, 4], [6, 4]]
      expect(black_pawn.two_step(starting_location)).to eq(expected_result_array)
    end
    it 'increments y axis for white pieces' do
      starting_location = [4, 4]
      expected_result_array = [[3, 4], [2, 4]]
      expect(white_pawn.two_step(starting_location)).to eq(expected_result_array)
    end
  end
  describe '#one_step' do
    it 'decrements the y axis for black pieces' do
      starting_location = [4, 4]
      expected_result_array = [[5, 4]]
      expect(black_pawn.one_step(starting_location)).to eq(expected_result_array)
    end
    it 'increments the y axis for white pieces' do
      starting_location = [4, 4]
      expected_result_array = [[3, 4]]
      expect(white_pawn.one_step(starting_location)).to eq(expected_result_array)
    end
  end
end
