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
