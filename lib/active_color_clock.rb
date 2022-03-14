# frozen_string_literal: true

class Active_color_clock
  attr_reader :active_color

  def initialize(active_color = 'w')
    @active_color = active_color
  end

  def update_active_color
    @active_color = if @active_color == 'w'
                      'b'
                    else
                      'w'
                    end
  end

  def fen_to_color
    color_hash = { 'white' => 'w', 'black' => 'b' }
    color_hash.key(@active_color)
  end

  def reverse_fen_color
    if fen_to_color == 'black'
      'white'
    else
      'black'
    end
  end
end
