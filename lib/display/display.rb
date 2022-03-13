# frozen_string_literal: true

module Display
  def announce_game_result
    if is_stalemate?
      'the game has come to a stalemate'
    elsif checkmate?
      announce_win(reverse_fen_color)
    elsif @move_repetitions == 3
      'the game has come to a draw as a result of repetetive movements'
    end
  end

  def announce_saved_game
    puts 'game has been saved'
  end

  def display_possible_commands
    puts 'save, resign, draw'
  end

  def choose_piece_or_command_menu
    puts 'Enter the location of a piece you would like to move or ls for possible commands'
  end

  def display_state_of_the_game
    reset_display
    announce_turn(@movement.fen_to_color)
  end

  def announce_turn(team_color)
    puts "#{team_color}'s move"
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
    @board.display_board
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

  def announce_win(team_color)
    "#{team_color} Wins the game!"
  end

  def display_board
    puts color_board
  end

  def color_board
    colored_board = ''
    row_index = 0
    last_colour = get_background_color(last_colour)
    while row_index <= 7
      colored_board += color_row(row_index, last_colour)
      last_colour = get_background_color(last_colour)
      row_index += 1
    end
    colored_board += '  a  b  c  d  e  f  g  h '.bold
    colored_board
  end

  def color_row(row_index, last_colour)
    column_index = 1
    coloured_row = (row_index + 1).to_s
    row = @board[row_index]
    row.each do |square|
      coloured_row += colorize_square(square, last_colour)
      last_colour = get_background_color(last_colour)
      column_index += 1
    end
    coloured_row += "\n"
    coloured_row
  end

  def colorize_square(square, last_colour)
    background_color_index = get_background_color(last_colour)
    if square.nil?
      coloured_square = '   '.bg_color(background_color_index)
    else
      text_colour_index = get_text_colour(square.team)
      color_piece = square.display_value.text_color(text_colour_index).bg_color(background_color_index)
      colored_whitespace = ' '.bg_color(background_color_index)
      coloured_square = "#{colored_whitespace}#{color_piece}#{colored_whitespace}"
    end
    coloured_square
  end

  def get_background_color(last_colour)
    if last_colour == 2
      1
    else
      2
    end
  end

  def get_text_colour(team)
    if team == 'white'
      9
    else
      0
    end
  end
end
