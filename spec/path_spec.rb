# frozen_string_literal: true

require 'load_game.rb'
describe Path do
  describe '#get_earliest_piece' do
    it 'should return the earliest encountered piece in the path' do
      string = "I'm here all alone"
      node_one = Node.new([3, 4], nil)
      node_two = Node.new([3, 5], nil)
      node_three = Node.new([3, 6], string)
      node_four = Node.new([3, 7], nil)
      node_array = [node_one, node_two, node_three, node_four]
      path = described_class.new(node_array)
      expect(path.get_earliest_piece).to eq string
    end
    it 'when theres a multitude of pieces still returns the earliest' do
      earliest_piece = 'wee'
      random_piece = 'woo'
      node_one = Node.new([3, 4], nil)
      node_two = Node.new([3, 5], earliest_piece)
      node_three = Node.new([3, 6], random_piece)
      node_array = [node_one, node_two, node_three]
      path = described_class.new(node_array)
      expect(path.get_earliest_piece).to eq earliest_piece
    end
  end
  describe '#get_location_of' do
    it 'should return the location of a given value' do
      string = "I'm here all alone"
      node_one = Node.new([3, 4], nil)
      node_two = Node.new([3, 5], nil)
      node_three = Node.new([3, 6], string)
      node_four = Node.new([3, 7], nil)
      node_array = [node_one, node_two, node_three, node_four]
      path = described_class.new(node_array)
      expect(path.get_location_of(string)).to eq [3, 6]
    end
  end
  describe '#path_until_first_piece' do
    context 'given a path returns a path to the earliest piece in the path' do
      it 'when the path has a piece it returns the path up to the piece' do
        node_one = Node.new([4, 3])
        node_two = Node.new([5, 3], 'wee')
        node_three = Node.new([6, 3])
        expected_path = [node_one, node_two]
        path = described_class.new([node_one, node_two, node_three])
        expect(path.path_until_first_piece.nodes).to eq(expected_path)
      end
    end
  end
  describe '#empty?' do
    it 'when path is empty returns true' do
      path = described_class.new
      expect(path.empty?).to be true
    end
  end
  describe '#valid?' do
    context 'checks if any of the nodes in the path are invalid' do
      it 'should return false when one node is invalid' do
        node_one = Node.new([555,321])
        path = described_class.new([node_one])
        expect(path.valid?).to be false
      end
      it 'should return true when none of the nodes are invalid' do
        node_one = Node.new([4, 3])
        path = described_class.new([node_one])
        expect(path.valid?).to be true
      end
    end
  end
end
