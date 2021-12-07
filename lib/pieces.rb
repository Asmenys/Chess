
class Piece
    def initialize(colour, name)
        @team = colour
        @display_value = PIECE_DISPLAY_VALUES[colour.to_sym][name.to_sym]
    end
end