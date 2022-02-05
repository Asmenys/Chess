# frozen_string_literal: true

require 'game'
require 'load_game'

describe Game do
  describe '#would_leave_king_in_check?' do
    context 'returns a bool based on whether the move leaves own players king in check' do
      xit 'when a pawn moves leaving the king in check for a bishop return true' do
        game = Load_game.new('8/8/8/4b3/3P4/2K5/8/8 w - - 0 1').game
        current_loc = [4, 3]
        kings_loc = game.find_king('b')
        destination_loc = [3, 3]
        expect(game.would_leave_king_in_check?(current_loc, destination_loc)).to be true
      end
      xit 'when a pawn moves but the king is not left in check for a bishop' do
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
  describe '#is_king_in_check?' do
    context 'given kings location, checks if the king is compromised' do
      xit 'when king is in check returns true' do
        kings_location = [4, 3]
        fen_string = '8/8/8/8/3k4/8/3R4/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be true
      end
      xit 'when king is not in check returns false' do
        kings_location = [4, 3]
        fen_string = '8/8/8/8/3k4/8/3B4/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be false
      end
      xit 'when theres a knight keeping the king in check return true' do
        kings_location = [4, 3]
        fen_string = '8/8/8/8/3kp3/3pp3/4N3/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be true
      end
      xit 'when king is not in check but a friendly piece includes the king in its possible paths returns false' do
        kings_location = [4, 3]
        fen_string = '8/8/4N3/8/3K4/8/8/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be false
      end
      xit 'returns false when surrounded by friendly pieces that all include king in their paths' do
        kings_location = [4, 3]
        fen_string = '8/8/2nq4/8/2rk4/3p4/5b2/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be false
      end
      xit 'true when surrounded by friendly pieces but under attack' do
        kings_location = [4, 3]
        fen_string = '8/8/2nq4/4pN2/2rkp3/3p4/5b2/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.is_king_in_check?(kings_location)).to be true
      end
    end
  end
end
