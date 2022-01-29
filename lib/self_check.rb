# frozen_string_literal: true

class Self_check
  def initialize(game)
    @board = game.board
    @alternate_game = game.clone
  end

  def self_check?(current_location, movement_destination)
    alternate_board = @board.clone
    piece = alternate_board.get_value_of_square(current_location)
    @alternate_game.board = alternate_board
    kings_location = @alternate_game.find_king(piece.team[0])
    @alternate_game.move_piece(current_location, movement_destination)
    @alternate_game.is_king_in_check?(kings_location)
  end
end
