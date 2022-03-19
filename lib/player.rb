# frozen_string_literal: true

class Player
  attr_reader :player_display

  def initialize
    @player_display = Player_display.new
  end

  def get_game_input
    gets.chomp
  end

  def is_a_command?(player_game_input)
    %w[save draw resign ls].include?(player_game_input.downcase)
  end

  def would_players_like_to_draw?
    @game_display.reset_display
    if player_would_like_to_propose_draw?
      @game_display.reset_display
      result = agrees_to_a_draw?
    end
    reset_display
    result
  end

  def would_like_to_propose_draw?
    puts 'would you like to propose a draw Y/n'
    response = gets.chomp
    %w[Y y].include?(response)
  end

  def agrees_to_a_draw?
    puts 'Would you like to agree to draw?'
    response = gets.chomp
    %w[Y y].include?(response)
  end

  def get_promotion_selection
    @game_display.promt_to_choose_promotion
    until valid_promotion_selection?(choice = gets.chomp)
      @game_display.promt_to_choose_promotion_after_invalid
    end
    choice
  end

  def valid_promotion_selection?(choice)
    valid_conversions = %w[Rook Queen Knight Bishop]
    valid_conversions.include?(choice)
  end
end
