# frozen_string_literal: true

require 'load_game'

describe Load_game do
  subject { described_class.new }

  describe '#setup_game_instance' do
    it 'sets up a new Game class instance based on the given fen string' do
      fen_string = 'pppppppp/8/pppppppp/8 w - - 0 0'
      game_instance = subject.setup_game_instance(fen_string)
      expect(game_instance.board.board[0][1].class).to be(Pawn)
    end
  end

  describe '#name_to_color' do
    it 'given a black rook returns Black' do
      name = 'r'
      expected_result = 'black'
      expect(subject.name_to_color(name)).to eq(expected_result)
    end
    it 'given a white rook returns White' do
      name = 'R'
      expected_result = 'white'
      expect(subject.name_to_color(name)).to eq(expected_result)
    end
  end

  describe '#split_fen_into_array' do
    it 'splits a fen string into an array of values' do
      fen_string = 'pppppppp/8/pppppppp/8 w - - 0 0'
      fen_array = subject.split_fen_into_array(fen_string)
      expect(fen_array[0]).to eq('pppppppp/8/pppppppp/8')
      expect(fen_array[1]).to eq('w')
      expect(fen_array[2]).to eq('-')
      expect(fen_array[3]).to eq('-')
      expect(fen_array[4]).to eq('0')
      expect(fen_array[5]).to eq('0')
    end
  end
  describe '#en_passant_to_coordinates' do
    context 'converts en_passant value from fen string into a location on the board for movement class' do
      it 'when given e3 returns [5, 4]' do
        expect(subject.en_passant_to_coordinates('e3')).to eq [5, 4]
      end
      it 'when given h1 returns [7, 7]' do
        expect(subject.en_passant_to_coordinates('h1')).to eq [7, 7]
      end
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
      fen_string = 'rnbqkbnr/8/pppppppp w - - 0 0'
      subject(:initializer) { described_class.new(fen_string) }
      it 'populates the board with pieces' do
        board = subject.game.board.board
        first_board_row = board[0]
        second_row = board[1]
        third_row = board[2]
        expect(first_board_row[1].class).to be(Knight)
        expect(second_row[2]).to be nil
        expect(third_row[3].class).to be(Pawn)
      end
    end
  end
end
