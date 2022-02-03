# frozen_string_literal: true

require 'load_game'

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

  describe '#find_king' do
    context 'returns the location of a given color king on the board' do
      it 'when w king is on [4, 3] returns [4, 3]' do
        board = Load_game.new('8/8/8/8/3K4/8/8/8 w - - 0 1').board
        expected_result = [4, 3]
        kings_color = 'w'
        expect(board.find_king(kings_color)).to eq expected_result
      end
      it 'when theres no king return nil' do
        board = Load_game.new('8/8/8/8/8/8/8/8 w - - 0 1').board
        kings_color = 'w'
        expect(board.find_king(kings_color)).to be nil
      end
      it 'when b king is on [7, 2] returns [7, 2]' do
        board = Load_game.new('8/8/8/8/8/8/8/2k5 w - - 0 1').board
        expected_result = [7, 2]
        kings_color = 'b'
        expect(board.find_king(kings_color)).to eq expected_result
      end
    end
  end
<<<<<<< HEAD
<<<<<<< Updated upstream
  describe '#is_square_friendly?' do
    it 'returns true when square holds a piece of same color as the given piece' do
      current_piece = Pawn.new('white', 'Pawn')
      square_loc = [4, 3]
      board = Load_game.new('8/8/8/8/3P4/8/8/8 w - - 0 1').board
      expect(board.is_square_friendly?(current_piece, square_loc)).to be true
    end
    it 'false when square holds a piece of unequal color' do
      current_loc = [4, 3]
      current_piece = Pawn.new('white', 'Pawn')
      board = Load_game.new('8/8/8/8/3p4/8/8/8 w - - 0 1').board
      expect(board.is_square_friendly?(current_piece, current_loc)).to be false
    end
    it 'when square is empty returns false' do
      current_loc = [4, 3]
      current_piece = Pawn.new('white', 'Pawn')
      board = Load_game.new('8/8/8/8/8/8/8/8 w - - 0 1').board
      expect(board.is_square_friendly?(current_piece, current_loc)).to be false
    end
  end
=======
>>>>>>> Stashed changes
=======
>>>>>>> path_node_gen
end
