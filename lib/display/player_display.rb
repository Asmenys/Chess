# frozen_string_literal: true

class Player_display
  def choose_piece_or_command
    puts 'Enter the location of a piece you would like to move or ls for possible commands'
  end

  def prompt_to_choose_piece_after_invalid_choice
    puts "Please choose a valid location on the board. A valid location is considered a location that holds a piece belonging to you written in board coordinates as such 'e4', 'a8'."
  end

  def choose_another
    puts 'Would you like to choose another piece?'
  end

  def promt_to_choose_piece
    puts 'Choose a piece on the board using its coordinates'
  end

  def prompt_to_choose_destination
    puts 'Choose a destination from the following list'
  end

  def promt_to_choose_destination_after_invalid_choice
    puts 'Please choose a valid destination from the following list'
  end

  def promt_to_choose_promotion
    puts 'Your pawn is eligible for promotion, choose a desirable promotion of your pawn, valid inputs are -> Queen, Rook, Knight, Bishop'
  end

  def promt_to_choose_promotion_after_invalid
    puts 'Please choose a valid promotion option, valid choices are -> Queen, Rook, Knight, Bishop'
  end
end
