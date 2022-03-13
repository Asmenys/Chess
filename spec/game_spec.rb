# frozen_string_literal: true

require 'game'
require 'load_game'

describe Game do
  subject(:default_game) { Load_game.new.game }

  describe '#is_a_command?' do
    context 'given a string returns a bool' do
      it 'when the string represents a command returns true' do
        expect(default_game.is_a_command?('resign')).to be true
      end
      it 'when the string does not represent a command returns false' do
        expect(default_game.is_a_command?('whatever')).to be false
      end
      it 'when the string is empty returns false' do
        expect(default_game.is_a_command?('')).to be false
      end
    end
  end

  describe '#self_to_fen' do
    it 'converts the state of the game to a fen string' do
      expect(default_game.self_to_fen).to eq('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    end
  end

  describe '#game_loop' do
    context 'plays the game' do
      it 'fools gambit leads into a black win' do
        allow(default_game).to receive(:get_player_game_input).and_return('f7', 'e2', 'g7', 'd1')
        allow(default_game).to receive(:get_valid_destination_selection).and_return('f6', 'e4', 'g5', 'h5')
        allow(default_game).to receive(:player_would_like_to_propose_draw?).and_return(false)
        expect(default_game.game_loop).to eq('black Wins the game!')
      end
      it 'dutch defense results in white win' do
        allow(default_game).to receive(:get_player_game_input).and_return('d7', 'f2', 'c8', 'h2', 'g4', 'g2', 'e7', 'g4',
                                                                          'd8')
        allow(default_game).to receive(:get_valid_destination_selection).and_return('d5', 'f4', 'g4', 'h3', 'h5', 'g4',
                                                                                    'e5', 'h5', 'h4')
        allow(default_game).to receive(:player_would_like_to_propose_draw?).and_return(false)
        expect(default_game.game_loop).to eq('white Wins the game!')
      end
    end
  end

  describe '#get_valid_destination_selection' do
    context 'upon invoking promps for an input and returns it if the input is valid' do
      invalid_input_example = 'im not a valid input :)'
      valid_input_example = '4'
      valid_index_input_example = 'e4'
      dummy_integer_array = Array.new(25) { |index| index += 1 }
      dummy_notation_array = Array.new(8) { |index| "e#{index += 1}" }
      promt_for_input_after_invalid = 'Please choose a valid destination from the following list'
      it 'upon calling once with invalid input and once with valid returns the input and prompts user to select twice' do
        allow(default_game).to receive(:gets).and_return(invalid_input_example, valid_input_example)
        expect(default_game.get_valid_destination_selection(dummy_integer_array)).to eq(valid_input_example)
      end
      it 'upon calling with an index that is included in the notation array returns the index' do
        allow(default_game).to receive(:gets).and_return(valid_index_input_example)
        expect(default_game.get_valid_destination_selection(dummy_notation_array)).to eq(valid_index_input_example)
      end
    end
  end

  describe 'valid_destination_selection?' do
    let(:dummy_array) { Array.new(25) { |index| index += 1 } }
    it 'when destination count is 25 and choice is 27 returns false' do
      expect(default_game.valid_destination_selection?('27', dummy_array)).to be false
    end
    it 'when destination count is 25 and choice is 12 returns true' do
      expect(default_game.valid_destination_selection?('12', dummy_array)).to be true
    end
  end

  describe 'valid_piece_selection?' do
    context 'given a string returns whether its a valid selection or not' do
      invalid_selection = 'b9'
      valid_selection = 'e4'
      game = Load_game.new('8/8/8/4P3/8/8/8/8 w - - 0 1').game
      it 'when given an invalid selection returns false' do
        expect(game.valid_piece_selection?(invalid_selection)).to be false
      end
      it 'when given a valid selection returns true' do
        expect(game.valid_piece_selection?(valid_selection)).to be true
      end
    end
  end
  describe '#is_notation?' do
    context 'returns true or false based on given string input' do
      is_not_notation = '43'
      is_notation = 'e4'
      it 'when given an input that is not board notation returns false' do
        expect(default_game.is_notation?(is_not_notation)).to be false
      end
      it 'given an input that is board notation returns true' do
        expect(default_game.is_notation?(is_notation)).to be true
      end
    end
  end
  describe '#selection_to_location' do
    it 'converts e4 to [3, 4]' do
      expect(default_game.selection_to_location('e4')).to eq [3, 4]
    end
    it 'converts g2 to [1, 6]' do
      expect(default_game.selection_to_location('g2')).to eq [1, 6]
    end
    it 'converts b8 to [7, 2]' do
      expect(default_game.selection_to_location('b8')).to eq [7, 1]
    end
  end
  describe '#location_to_selection' do
    it 'converts [3, 4] to e4' do
      expect(default_game.location_to_selection([3, 4])).to eq 'e4'
    end
    it 'converts [1, 6] to g2' do
      expect(default_game.location_to_selection([1, 6])).to eq 'g2'
    end
  end
  describe '#destinations_to_notation' do
    it 'converts an array of destination indexes to notation' do
      destination_array = [[1, 2], [1, 3], [1, 4], [1, 5], [1, 6]]
      expected_notation_array = %w[c2 d2 e2 f2 g2]
      expect(default_game.destinations_to_notation(destination_array)).to eq expected_notation_array
    end
  end
end
