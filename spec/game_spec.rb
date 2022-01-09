# frozen_string_literal: true

require 'game'

describe Game do
  describe 'filter_empty_paths' do
    context 'it removes empty paths from an array of paths' do
      game = described_class.new

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
  describe 'validate_path' do
    context 'given a path returns a path to the earliest piece in the path' do
      board = Board.new
      game = Game.new(board)
      it 'when the path does not include a piece returns a full path' do
        path = [[4, 3], [5, 3], [6, 3]]
        expect(game.validate_path(path)).to eq(path)
      end
      it 'when the path has a piece it returns the path up to the piece' do
        path = [[4, 3], [5, 3], [6, 3]]
        allow(board).to receive(:get_value_of_square).and_return(nil, 'piece')
        expected_result = [[4,3], [5,3]]
        expect(game.validate_path(path)).to eq(expected_result)
      end
    end
  end
end
