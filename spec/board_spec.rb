# frozen_string_literal: true

require 'board'

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
end
