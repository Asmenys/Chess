# frozen_string_literal: true

class Board_display
  def initialize(board)
    @board = board
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
    row = @board.board[row_index]
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
