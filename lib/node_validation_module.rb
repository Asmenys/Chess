# frozen_string_literal: true

module Node_validation
  def valid_index?(index)
    result = false
    result = true if index >= 0 && (index < 8)
    result
  end

  def valid_dimensions?(location)
    result = false
    result = true if valid_index?(location[0]) && valid_index?(location[1])
    result
  end
end
