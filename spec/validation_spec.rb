# frozen_string_literal: true

require 'node_validation_module'

describe Node_validation do
  include Node_validation
  describe '#valid_index?' do
    context 'given an index returns whether bool based on the value of the index' do
      it 'when given an index that is outside the board returns false' do
        index = 9
        expect(valid_index?(index)).to be false
      end
      it 'when given an index that belongs to the board returns true' do
        index = 0
        expect(valid_index?(index)).to be true
      end
    end
  end
  describe '#valid_dimensions?' do
    context 'given an array of dimensions returns a boolean based on whether the dimensions belong to the board or not.' do
      it 'when given a dimension that belongs on the board returns true' do
        dimensions = [4, 3]
        expect(valid_dimensions?(dimensions)).to be true
      end
      it 'when given an illegal set of dimensions returns false' do
        dimensions = [4343, 23]
        expect(valid_dimensions?(dimensions)).to be false
      end
    end
  end
end
