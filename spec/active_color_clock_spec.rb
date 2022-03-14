# frozen_string_literal: true

require 'load_game'
describe Active_color_clock do
  describe '#fen_to_color' do
    context 'converts the active fen color to a color used by other functions' do
      it 'when current color is w returns white' do
        default_clock = described_class.new
        expect(default_clock.fen_to_color).to eq 'white'
      end
      it 'when current color is b returns black' do
        default_clock = described_class.new('b')
        expect(default_clock.fen_to_color).to eq 'black'
      end
    end
  end
end
