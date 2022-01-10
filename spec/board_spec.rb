# frozen_string_literal: true

require 'game'

describe Board do
  describe '#add_piece' do
    subject(:board) { described_class.new }
    context 'instantiates a piece inside a square based on given parameneters' do
      it 'creates black rook at [3,4]' do
        location = [3, 4]
        piece_type = 'Rook'
        colour = 'black'
        board.add_piece(colour, piece_type, location)
        expect(board.board[3][4].name).to eq(piece_type)
      end
    end
  end
  describe '#validate_move_array' do
    subject(:board) { described_class.new }
    context 'validates an array of movements removing invalid ones.' do
      it 'cleans the array of invalid inputs' do
        array = [[-1, 0], [2, 0], [44, 32], [4, 3]]
        clean_array = subject.validate_move_array(array)
        expect(clean_array).to eq([[2, 0], [4, 3]])
      end
    end
  end
  describe '#create_piece' do
    subject(:board) { described_class.new }
    it 'creates a play piece to initialize on the board' do
      piece_type = 'Rook'
      piece_color = 'black'
      piece = board.create_piece(piece_color, piece_type)
      expect(piece.class).to be(Rook)
      expect(piece.team).to eq(piece_color)
      expect(piece.name).to eq(piece_type)
    end
  end
  describe '#valid_index?' do
    subject(:board) { described_class.new }
    context 'given an index returns whether bool based on the value of the index' do
      it 'when given an index that is outside the board returns false' do
        index = 9
        expect(board.valid_index?(index)).to be false
      end
      it 'when given an index that belongs to the board returns true' do
        index = 0
        expect(board.valid_index?(index)).to be true
      end
    end
  end
  describe '#valid_dimensions?' do
    subject(:board) { described_class.new }
    context 'given an array of dimensions returns a boolean based on whether the dimensions belong to the board or not.' do
      it 'when given a dimension that belongs on the board returns true' do
        dimensions = [4, 3]
        expect(board.valid_dimensions?(dimensions)).to be true
      end
      it 'when given an illegal set of dimensions returns false' do
        dimensions = [4343, 23]
        expect(board.valid_dimensions?(dimensions)).to be false
      end
    end
  end
  describe '#empty_location?' do
    subject(:board) { described_class.new }
    context 'given a location returns whether the node is populated or not' do
      it 'when given a location of an empty node' do
        location = [4, 3]
        expect(board.empty_location?(location)).to be true
      end
      it 'when given a location of a populated node' do
        location = [4, 3]
        allow(board).to receive(:get_value_of_square).and_return('not nil')
        expect(board.empty_location?(location)).to be false
      end
    end
  end
  describe '#set_square_to' do
    subject(:board) { described_class.new }
    it 'given a location and value sets the node of the corresponding location to the given value' do
      location = [4, 3]
      value = 'im a value'
      board.set_square_to(location, value)
      expect(board.get_value_of_square(location)).to eq(value)
    end
  end
end
