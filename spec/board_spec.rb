require 'board.rb'

describe Board do
    describe '#add_piece' do
        subject(:board){described_class.new}
        context 'instantiates a piece inside a square based on given parameneters' do
            it 'creates black rook at [3,4]' do
                location = [3,4]
                piece_type = "Rook"
                colour = "black"
                board.add_piece(colour, piece_type, location)
                expect(board.board[3][4].name).to eq(piece_type)
            end
        end
    end
end