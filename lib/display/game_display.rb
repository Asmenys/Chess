# frozen_string_literal: true

class Game_display
  def initialize(game)
    @game = game
  end

  def game_result_announcement(game_result_message)
    if game_result_message.empty?
      announce_game_result
    else
      game_result_message
    end
  end

  def announce_turn(team_color)
    puts "#{team_color}'s move"
  end

  def display_state_of_the_game
    reset_display
    announce_turn(@game.movement.fen_to_color)
  end

  def announce_game_result
    if @game.is_stalemate?
      'the game has come to a stalemate'
    elsif @game.checkmate?
      announce_win(@game.reverse_fen_color)
    elsif @game.move_repetitions == 3
      'the game has come to a draw as a result of repetetive movements'
    end
  end

  def announce_win(team_color)
    "#{team_color} Wins the game!"
  end

  def display_state_of_the_game
    reset_display
    announce_turn(@game.movement.fen_to_color)
  end

  def choose_piece_or_command_menu
    puts 'Enter the location of a piece you would like to move or ls for possible commands'
  end

  def display_destinations(destination_array)
    result_string = ''
    destination_array.each_with_index do |destination, index|
      result_string += "\n" if !index.zero? && (index % 5).zero?
      notation_display_unit = "#{index}: #{destination} "
      result_string += notation_display_unit
    end
    puts result_string
  end

  def prompt_immovable_piece
    puts 'This piece does not have any legal moves, please choose another piece'
  end

  def promt_to_choose_promotion
    puts 'Your pawn is eligible for promotion, choose a desirable promotion of your pawn, valid inputs are -> Queen, Rook, Knight, Bishop'
  end

  def promt_to_choose_promotion_after_invalid
    puts 'Please choose a valid promotion option, valid choices are -> Queen, Rook, Knight, Bishop'
  end

  def reset_display
    system 'clear'
    @game.board_display.display_board
  end

  def announce_saved_game
    puts 'game has been saved'
  end

  def prompt_possible_movements
    puts 'This piece has the following movements available to it'
  end

  def prompt_whether_wants_to_move_with_this_piece
    puts 'Do you wish to move with this piece? Y/n'
  end

  def prompt_to_choose_destination
    puts 'Choose a destination from the following list'
  end

  def promt_to_choose_destination_after_invalid_choice
    puts 'Please choose a valid destination from the following list'
  end

  def promt_to_choose_piece
    puts 'Choose a piece on the board using its coordinates'
  end

  def prompt_to_choose_piece_after_invalid_choice
    puts "Please choose a valid location on the board. A valid location is considered a location that holds a piece belonging to you written in board coordinates as such 'e4', 'a8'."
  end

  def choose_another
    puts 'Would you like to choose another piece?'
  end
end
