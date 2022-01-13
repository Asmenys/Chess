# frozen_string_literal: true

require 'game'

describe Fen_to_board do
  subject { described_class.new }
  describe '#name_to_color' do
    it 'given a black rook returns Black' do
      name = 'R'
      expected_result = 'black'
      expect(subject.name_to_color(name)).to eq(expected_result)
    end
    it 'given a white rook returns White' do
      name = 'r'
      expected_result = 'white'
      expect(subject.name_to_color(name)).to eq(expected_result)
    end
  end

  describe '#is_type_of_piece?' do
    it 'given a character corresponding to a piece returns true' do
      expect(subject.is_type_of_piece?('k')).to be true
    end
    it 'given anything else returns false' do
      expect(subject.is_type_of_piece?('h')).to be false
    end
  end

  describe '#name_to_piece' do
    it 'given a symbol of a black rook returns Rook' do
      expect(subject.name_to_piece('R')).to eq('Rook')
    end
    it 'given a symbol that does not exists returns nil' do
      expect(subject.name_to_piece('dgfa')).to be nil
    end
  end
  describe '#empty_square?' do
    it 'given a string integer, returns true' do
      expect(subject.empty_square?('4')).to be true
    end
    it 'given anything else returns false' do
      expect(subject.empty_square?('a')).to be false
    end
  end

  describe '#end_of_row?' do
    it 'given a forward slash, returns true' do
      expect(subject.end_of_row?('/')).to be true
    end
    it 'given anything else returns false' do
      expect(subject.end_of_row?('a')).to be false
    end
  end

  describe '#initialize_pieces' do
    context 'given a board and a fen string it populates the board' do
      fen_string = 'rnbqkbnr/8/pppppppp'
      subject(:initializer) { described_class.new(fen_string) }
      it 'populates the board' do
        subject.initialize_pieces(fen_string)
        board = subject.board.board
        first_board_row = board[0]
        second_row = board[1]
        third_row = board[2]
        expect(first_board_row[1].class).to be(Knight)
      end
    end
  end
end
