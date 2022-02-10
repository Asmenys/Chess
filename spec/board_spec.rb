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
      path = board.path_nodes_to_path(path_nodes).first
      expect(path.nodes.length).to eq 3
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
end
