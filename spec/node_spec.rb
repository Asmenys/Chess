require 'load_game.rb'
describe Node do
    describe '#valid_index?' do
        context 'returns a bool based on whether the given index meets requirements' do
            it 'returns false when the index is invalid' do
                node = described_class.new([4,3])
                expect(node.valid_index?(99)).to be false
            end
            it 'returns true when the index is valid' do
                node = described_class.new([3, 4])
                expect(node.valid_index?(3)).to be true
            end
        end
    end
    describe '#valid?' do
        context 'returns a bool based on whether the nodes dimensions are valid or not' do
            it 'returns false when dimensions are invalid' do
                node = described_class.new([6467,2342])
                expect(node.valid?).to be false
            end
            it 'returns true when dimensions are valid' do
                node = described_class.new([3, 4])
                expect(node.valid?).to be true
            end
        end
    end
end