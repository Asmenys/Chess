# frozen_string_literal: true

require 'load_game'
describe Movement_directions do
  describe '#moves_two_pieces?' do
    it 'returns true when the direction would result in a movement of two pieces' do
      starting_loc = [4, 3]
      starting_loc_two = [5, 7]
      destination = [5, 7]
      destination_two = [4, 3]
      directions = described_class.new(starting_loc, destination, nil, starting_loc_two, destination_two)
      expect(directions.moves_two_pieces?).to be true
    end
    it 'returns false when it doesnt' do
      starting_loc = [4, 3]
      destination = [5, 7]
      directions = described_class.new(starting_loc, destination)
      expect(directions.moves_two_pieces?).to be false
    end
  end
  describe '#creates_en_passant?' do
    it 'returns true when theres a direction for a new en_passant square' do
      starting_loc = [6, 0]
      destination = [4, 0]
      en_passant = [5, 0]
      destination = described_class.new(starting_loc, destination, en_passant)
      expect(destination.creates_en_passant?).to be true
    end
    it 'returns false when no en_passant will be created' do
      starting_loc = [6, 0]
      destination = [5, 0]
      destination = described_class.new(starting_loc, destination)
      expect(destination.creates_en_passant?).to be false
    end
  end
end
