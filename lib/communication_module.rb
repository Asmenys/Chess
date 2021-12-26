# frozen_string_literal: true

module Communication
  def notation_to_location(notation)
    [notation[1].to_i - 1, notation[0].ord - 97]
  end
end
