# frozen_string_literal: true

module Display
  def display_board
    row_index = 1
    corner_down_left = "\u2554"
    corner_down_right = "\u2557"
    corner_up_left = "\u255A"
    corner_up_right = "\u255D"
    base_line = "\u2550"
    wall_line = "\u2551"
    column_indexes = ''
    board_line = "  #{wall_line}#{base_line*39}" + wall_line
    board_top_line = "  #{corner_down_left}" + "#{base_line * 39}" + "#{corner_down_right}"
    board_bottom_line = "  #{corner_up_left}" + "#{base_line * 39}" + "#{corner_up_right}"
    p board_top_line
    @board.each do |row|
      board_row = ''
      row.each do |square|
        board_row += if square.nil?
                       "#{wall_line}    "
                     else
                       "#{wall_line}  #{square.display_value} "
                     end
      end
      board_row += wall_line.to_s
      board_row = row_index.to_s + " " + board_row
      row_index += 1
      p board_row
      case row_index
      when 9
        p board_bottom_line
      else
      p board_line
      end
    end
  end
end
