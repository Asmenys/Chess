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
    active_color = @alternate_game.fen_to_color
    kings_location = @alternate_game.board.find_king(active_color)
    move_piece(current_location, movement_destination)
    @alternate_game.is_king_in_check?
  end

  def move_piece(current_location, movement_destination)
    board = @alternate_game.board
    piece = board.get_value_of_square(current_location)
    board.set_square_to(current_location, nil)
    board.set_square_to(movement_destination, piece)
  end
end
