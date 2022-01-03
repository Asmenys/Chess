# frozen_string_literal: true

require 'game'

describe Horizontal_moveset do
  subject(:rook) { Rook.new('black', 'Rook') }
  describe '#get_path_on_axis' do
    context 'generates a path on given axis and directions' do
      it 'generates a path directly up' do
        current_location = [4, 3]
        expected_result = [[3, 3], [2, 3], [1, 3], [0, 3]]
        expect(rook.get_path_on_axis(current_location, 0, -1)).to eq(expected_result)
      end
      it 'generates a path directly down' do
        current_location = [4, 3]
        expected_result = [[5, 3], [6, 3], [7, 3]]
        expect(rook.get_path_on_axis(current_location, 0, 1)).to eq(expected_result)
      end
      it 'generates a path to the left' do
        current_location = [4, 3]
        expected_result = [[4, 2], [4, 1], [4, 0]]
        expect(rook.get_path_on_axis(current_location, 1, -1)).to eq(expected_result)
      end
      it 'generates a path to the right' do
        current_location = [4, 3]
        expected_result = [[4, 4], [4, 5], [4, 6], [4, 7]]
        expect(rook.get_path_on_axis(current_location, 1, 1)).to eq(expected_result)
      end
    end
  end
  describe '#moves_on_axis' do
    it 'generates all possible paths on axis' do
      current_location = [4, 3]
      expected_result = [[[5, 3], [6, 3], [7, 3]], [[3, 3], [2, 3], [1, 3], [0, 3]], [[4, 2], [4, 1], [4, 0]],
                         [[4, 4], [4, 5], [4, 6], [4, 7]]]
      expect(rook.moves_on_axis(current_location)).to eq(expected_result)
    end
  end
end
