# frozen_string_literal: true

require 'load_game'

describe Board do
  describe '#self_to_fen' do
    context 'converts the board to a fen string for saving purposes' do
      empty_board = Load_game.new('8/8/8/8/8/8/8/8 w - - 0 1').game.board
      starting_position_board = Load_game.new('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1').game.board
      expected_empty_board_fen_string = '8/8/8/8/8/8/8/8'
      expected_starting_position_board_fen_string = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'
      partially_empty_board = Load_game.new('rnbqkbnr/ppp4p/8/8/8/8/PPPPPPPP/R2QKBNR w KQkq - 0 1').game.board
      expected_partially_empty_board_fen_string = 'rnbqkbnr/ppp4p/8/8/8/8/PPPPPPPP/R2QKBNR'
      it 'empty board is converted to the expected empty fen string' do
        expect(empty_board.self_to_fen).to eq expected_empty_board_fen_string
      end
      it 'starting position board is converted to the expected starting pos fen string' do
        expect(starting_position_board.self_to_fen).to eq expected_starting_position_board_fen_string
      end
      it 'partially empty board string matches the expected fen string' do
        expect(partially_empty_board.self_to_fen).to eq expected_partially_empty_board_fen_string
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

  describe '#find_king' do
    context 'returns the location of a given color king on the board' do
      it 'when w king is on [4, 3] returns [4, 3]' do
        board = Load_game.new('8/8/8/8/3K4/8/8/8 w - - 0 1').board
        expected_result = [4, 3]
        kings_color = 'white'
        expect(board.find_king(kings_color).index).to eq expected_result
      end
      it 'when b king is on [7, 2] returns [7, 2]' do
        board = Load_game.new('8/8/8/8/8/8/8/2k5 w - - 0 1').board
        expected_result = [7, 2]
        kings_color = 'black'
        expect(board.find_king(kings_color).index).to eq expected_result
      end
    end
  end

  describe '#get_adjacent_paths' do
    context 'returns paths adjacent to given location horizontally' do
      game = Load_game.new('8/8/8/8/8/8/8/R2K2PN b - e3 0 1').game
      current_location = [7, 3]
      adjacent_paths = game.board.get_adjacent_paths(current_location)
      adjacent_path_left = adjacent_paths.first
      adjacent_path_right = adjacent_paths.last
      it 'the paths contain pieces as their last nodes' do
        last_nodes = []
        last_nodes << adjacent_path_left.last_node
        last_nodes << adjacent_path_right.last_node
        expect(last_nodes.all? { |node| node.value.is_a?(Piece) }).to be true
      end
      it 'they go across the board' do
        expect(adjacent_path_left.length + adjacent_path_right.length).to eq 7
      end
    end
  end

  describe '#filter_paths' do
    it 'filters out empty and invalid paths from a path array' do
      path_one = Path.new([Node.new([4, 3]), Node.new([5, 3]), Node.new([5, 4])])
      path_two = Path.new([Node.new([443, 324]), Node.new([4, 4]), Node.new([44, 3])])
      path_three = Path.new([Node.new([4, 4]), Node.new([2, 2]), Node.new([1, 3])])
      board = described_class.new
      expected_path_result = [path_one, path_three]
      expect(board.filter_paths([path_one, path_two, path_three])).to eq expected_path_result
    end
  end
  describe '#indexes_to_nodes' do
    it 'given an array of node indexes, converts them to Node objects' do
      node_indexes = [[4, 3], [4, 4], [4, 5]]
      board = described_class.new
      nodes = board.indexes_to_nodes(node_indexes)
      expect(nodes[0].index).to eq node_indexes[0]
      expect(nodes.all? { |node| node.instance_of?(Node) }).to be true
    end
  end
  describe '#path_nodes_to_path' do
    it 'given an array of path nodes, creates a path out of given nodes' do
      board = described_class.new
      path_node_indexes = [[3, 4], [4, 4], [5, 5]]
      path_nodes = [board.indexes_to_nodes(path_node_indexes)]
      path = board.path_nodes_to_path(path_nodes)
      expect(path.nodes.all? { |node| node.instance_of?(Node) })
    end
  end
  describe '#get_attack_path_nodes' do
    it 'given a location of a node, it returns all the possible attack nodes' do
      board = described_class.new
      expected_result_array = [[[5, 3], [6, 3], [7, 3]],
                               [[3, 3], [2, 3], [1, 3], [0, 3]],
                               [[4, 2], [4, 1], [4, 0]],
                               [[4, 4], [4, 5], [4, 6], [4, 7]],
                               [[5, 5]],
                               [[5, 1]],
                               [[6, 4]],
                               [[6, 2]],
                               [[2, 2]],
                               [[2, 4]],
                               [[3, 5]],
                               [[3, 1]],
                               [[5, 2], [6, 1], [7, 0]],
                               [[5, 4], [6, 5], [7, 6]],
                               [[3, 2], [2, 1], [1, 0]],
                               [[3, 4], [2, 5], [1, 6], [0, 7]]]
      expect(board.get_attack_path_nodes([4, 3])).to eq expected_result_array
    end
  end
  describe '#node_attack_paths' do
    it 'given a location of a node, returns all the possible attack paths' do
      board = described_class.new
      attack_paths = board.node_attack_paths([0, 0])
      expect(attack_paths.empty?).to be false
      expect(attack_paths.all?(&:valid?)).to be true
    end
  end
  describe '#delete_empty_node_indexes' do
    it 'deletes paths that are empty' do
      path_array = [[], ['whatever'], ['okay']]
      expected_result = [path_array[1], path_array[2]]
      expect(subject.delete_empty_node_indexes(path_array)).to eq expected_result
    end
  end
  describe '#valid_location?' do
    it 'given an invalid location returns false' do
      invalid_location = [423_423, 43_434]
      expect(subject.valid_location?(invalid_location)).to be false
    end
    it 'given a valid location returns true' do
      valid_location = [0, 0]
      expect(subject.valid_location?(valid_location)).to be true
    end
    it 'given a valid location returns true' do
      valid_location = [7, 7]
      expect(subject.valid_location?(valid_location)).to be true
    end
    it 'given an invalid location returns false' do
      invalid_location = [-7, -1]
      expect(subject.valid_location?(invalid_location)).to be false
    end
  end
  describe '#delete_invalid_paths' do
    it 'given a path deletes it if it contains invalid nodes' do
      path_array = [[[-4, 3], [5, 2]], [[4, 3], [5, 4], [5, 6]]]
      expect(subject.delete_invalid_paths(path_array)).to eq [path_array.last]
    end
  end
  describe '#array_of_path_node_indexes_to_paths' do
    context 'converts an array of paths in a form of node indexes converts to an array of paths' do
      board = described_class.new
      array_of_path_node_indexes = [[[5, 3], [6, 3], [7, 3]],
                                    [[3, 3], [2, 3], [1, 3], [0, 3]],
                                    [[4, 2], [4, 1], [4, 0]],
                                    [[4, 4], [4, 5], [4, 6], [4, 7]]]
      array_of_paths = board.array_of_path_node_indexes_to_paths(array_of_path_node_indexes)
      it 'generates an array consisting of 4 paths' do
        expect(array_of_paths.length).to be 4
      end
      it 'each path consists of the given indexes' do
        path_indexes = []
        array_of_paths.each do |path|
          path_indexes << path.nodes_as_indexes
        end
        expect(path_indexes).to eq array_of_path_node_indexes
      end
    end
  end
end
