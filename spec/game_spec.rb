# frozen_string_literal: true

require 'game'
require 'load_game'

describe Game do
  describe '#filter_empty_paths' do
    context 'it removes empty paths from an array of paths' do
      game = described_class.new(Board.new)
      it 'when there are no empty paths returns self' do
        array_of_paths = [[1], [2], [3], [4]]
        expect(game.filter_empty_paths(array_of_paths)).to eq(array_of_paths)
      end
      it 'when theres an empty path, removes it' do
        array_of_paths = [[1], [], [2], [3], [], [], [6], []]
        expected_result = [[1], [2], [3], [6]]
        expect(game.filter_empty_paths(array_of_paths)).to eq(expected_result)
      end
      it 'when all paths are empty' do
        array_of_paths = [[], [], [], [], []]
        expected_result = []
        expect(game.filter_empty_paths(array_of_paths)).to eq(expected_result)
      end
    end
  end
  describe '#get_possible_end_points' do
    context 'it returns the possible end points from a piece for movement' do
      it 'from black pawn' do
        current_loc = [4, 3]
        game = Load_game.new('8/8/8/8/3P4/8/8/8 w - - 0 1').game
        expected_end_points = [[3, 3], [2, 3]]
        expect(game.get_possible_end_points(current_loc)).to eq expected_end_points
      end
      it 'from a black pawn that has already moved' do
        game = Load_game.new('8/8/8/8/3P4/8/8/8 w - - 0 1').game
        pawn = game.board.get_value_of_square([4, 3])
        pawn.moved
        game.board.set_square_to([4, 3], pawn)
        expected_end_points = [[3, 3]]
        expect(game.get_possible_end_points([4, 3])).to eq expected_end_points
      end
      it 'from a white rook' do
        current_loc = [7, 0]
        game = Load_game.new('8/8/8/8/8/8/8/R7 w - - 0 1').game
        expected_end_points = [[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0], [7, 1], [7, 2], [7, 3], [7, 4],
                               [7, 5], [7, 6], [7, 7]]
        expect(game.get_possible_end_points(current_loc)).to eq expected_end_points
      end
      it 'from a black bishop' do
        current_loc = [4, 3]
        game = Load_game.new('8/8/8/8/3b4/8/8/8 w - - 0 1').game
        expected_end_points = [[3, 2], [2, 1], [1, 0], [5, 4], [6, 5], [7, 6], [5, 2], [6, 1], [7, 0], [3, 4], [2, 5], [1, 6],
                               [0, 7]]
        expect(game.get_possible_end_points(current_loc)).to eq expected_end_points
      end
      it 'from a white knight' do
        current_loc = [4, 3]
        game = Load_game.new('8/8/8/8/3N4/8/8/8 w - - 0 1').game
        expected_end_points = [[5, 5], [5, 1], [6, 4], [6, 2], [2, 2], [2, 4], [3, 5], [3, 1]]
        expect(game.get_possible_end_points(current_loc)).to eq expected_end_points
      end
      it 'from a white knight surrounded by friendly pieces' do
        current_loc = [4, 3]
        game = Load_game.new('8/8/2P1P3/1P3P2/3N4/1P3P2/2P1P3/8 w - - 0 1').game
        expected_end_points = []
        expect(game.get_possible_end_points(current_loc)).to eq expected_end_points
      end
    end
  end
  describe '#find_king' do
    context 'returns the location of a given color king on the board' do
      it 'when w king is on [4, 3] returns [4, 3]' do
        game = Load_game.new('8/8/8/8/3K4/8/8/8 w - - 0 1').game
        expected_result = [4, 3]
        kings_color = 'w'
        expect(game.find_king(kings_color)).to eq expected_result
      end
      it 'when theres no king return nil' do
        game = Load_game.new('8/8/8/8/8/8/8/8 w - - 0 1').game
        kings_color = 'w'
        expect(game.find_king(kings_color)).to be nil
      end
      it 'when b king is on [7, 2] returns [7, 2]' do
        game = Load_game.new('8/8/8/8/8/8/8/2k5 w - - 0 1').game
        expected_result = [7, 2]
        kings_color = 'b'
        expect(game.find_king(kings_color)).to eq expected_result
      end
    end
  end
  describe '#would_leave_king_in_check?' do
    context 'returns a bool based on whether the move leaves own players king in check' do
      it 'when a pawn moves leaving the king in check for a bishop return true' do
        game = Load_game.new('8/8/8/4b3/3P4/2K5/8/8 w - - 0 1').game
        current_loc = [4, 3]
        kings_loc = game.find_king('b')
        destination_loc = [3, 3]
        expect(game.would_leave_king_in_check?(current_loc, destination_loc)).to be true
      end
      it 'when a pawn moves but the king is not left in check for a bishop' do
        game = Load_game.new('8/8/8/4b3/8/2KP4/8/8 w - - 0 1').game
        current_loc = [5, 3]
        kings_loc = game.find_king('b')
        destination_loc = [4, 3]
        expect(game.would_leave_king_in_check?(current_loc, destination_loc)).to be false
      end
    end
  end
  describe '#is_square_friendly?' do
    it 'returns true when square holds a piece of same color as the given piece' do
      current_piece = Pawn.new('white', 'Pawn')
      square_loc = [4, 3]
      game = Load_game.new('8/8/8/8/3P4/8/8/8 w - - 0 1').game
      expect(game.is_square_friendly?(current_piece, square_loc)).to be true
    end
    it 'false when square holds a piece of unequal color' do
      current_loc = [4, 3]
      current_piece = Pawn.new('white', 'Pawn')
      game = Load_game.new('8/8/8/8/3p4/8/8/8 w - - 0 1').game
      expect(game.is_square_friendly?(current_piece, current_loc)).to be false
    end
    it 'when square is empty returns false' do
      current_loc = [4, 3]
      current_piece = Pawn.new('white', 'Pawn')
      game = Load_game.new('8/8/8/8/8/8/8/8 w - - 0 1').game
      expect(game.is_square_friendly?(current_piece, current_loc)).to be false
    end
  end
  describe '#path_until_first_piece' do
    context 'given a path returns a path to the earliest piece in the path' do
      board = Board.new
      game = Game.new(board)
      it 'when the path does not include a piece returns a full path' do
        path = [[4, 3], [5, 3], [6, 3]]
        expect(game.path_until_first_piece(path)).to eq(path)
      end
      it 'when the path has a piece it returns the path up to the piece' do
        path = [[4, 3], [5, 3], [6, 3]]
        allow(board).to receive(:get_value_of_square).and_return(nil, 'piece')
        expected_result = [[4, 3], [5, 3]]
        expect(game.path_until_first_piece(path)).to eq(expected_result)
      end
    end
  end
  describe '#get_earliest_piece_with_location' do
    context 'given a path, returns the earliest encounter with a piece in the path' do
      board = Board.new
      game = Game.new(board)
      it 'when the path does not include any pieces returns an array of nils' do
        path = [[3, 4], [4, 5], [5, 6]]
        expected_result = nil
        expect(game.get_earliest_piece_with_location(path)).to eq(expected_result)
      end
      it 'when the path includes a piece, it returns the piece and its location' do
        path = [[3, 4], [4, 5], [5, 6]]
        expected_result = ['piece', [4, 5]]
        allow(board).to receive(:get_value_of_square).and_return(nil, 'piece', nil)
        expect(game.get_earliest_piece_with_location(path)).to eq(expected_result)
      end
    end
  end
  describe '#is_king_in_check?' do
    context 'given kings location, checks if the king is compromised' do
      it 'when king is in check returns true' do
        kings_location = [4, 3]
        fen_string = '8/8/8/8/3k4/8/3R4/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be true
      end
      it 'when king is not in check returns false' do
        kings_location = [4, 3]
        fen_string = '8/8/8/8/3k4/8/3B4/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be false
      end
      it 'when theres a knight keeping the king in check return true' do
        kings_location = [4, 3]
        fen_string = '8/8/8/8/3kp3/3pp3/4N3/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be true
      end
      it 'when king is not in check but a friendly piece includes the king in its possible paths returns false' do
        kings_location = [4, 3]
        fen_string = '8/8/4N3/8/3K4/8/8/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be false
      end
      it 'returns false when surrounded by friendly pieces that all include king in their paths' do
        kings_location = [4, 3]
        fen_string = '8/8/2nq4/8/2rk4/3p4/5b2/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be false
      end
      it 'true when surrounded by friendly pieces but under attack' do
        kings_location = [4, 3]
        fen_string = '8/8/2nq4/4pN2/2rkp3/3p4/5b2/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be true
      end
    end
  end
end
