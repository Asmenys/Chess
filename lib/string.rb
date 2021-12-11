# frozen_string_literal: true

class String
  def text_color(color_code)
    "\e[3#{color_code}m#{self}\e[0m"
  end

  def bg_color(color_code)
    "\e[4#{color_code}m#{self}\e[0m"
  end
end
