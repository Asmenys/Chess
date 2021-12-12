# frozen_string_literal: true

require_relative 'string'

module Display
  def display_board
    row_index = 1
    last_colour = 5
    @board.each do |row|
      column_index = 1
      coloured_row = ''
      last_colour = get_background_color(last_colour)
      row.each do |square|
        coloured_row += colorize_square(square, last_colour)
        last_colour = get_background_color(last_colour)
        column_index += 1
      end
      row_index += 1
      puts coloured_row
    end
  end

  def colorize_square(square, last_colour)
    background_color_index = get_background_color(last_colour)
    if square.nil?
      coloured_square = '   '.bg_color(background_color_index)
    else
      text_colour_index = get_text_colour(square.team)
      coloured_square = " #{square.display_value} ".text_color(text_colour_index).bg_color(text_colour_index)
    end
    coloured_square
  end

  def get_background_color(last_colour)
    if last_colour == 5
      1
    else
      5
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
