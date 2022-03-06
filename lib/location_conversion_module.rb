# frozen_string_literal: true

module Location_conversion
  def selection_to_location(selection)
    selection = selection.chars
    row_index = selection.last.to_i - 1
    column_index = selection.first.ord - 97
    [row_index, column_index]
  end

  def location_to_selection(location)
    selection = ''
    selection += (location[1] + 97).chr
    selection += (location[0] + 1).to_s
    selection
  end
end
