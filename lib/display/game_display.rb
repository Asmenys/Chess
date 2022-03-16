# frozen_string_literal: true

class Game_display
  def initialize(game)
    @game = game
  end

  def game_result_announcement(game_result_message)
    if game_result_message.empty?
      announce_game_result
    else
      game_result_message
    end
  end

  def announce_turn(team_color)
    puts "#{team_color}'s move"
  end

  def display_state_of_the_game
    reset_display
    announce_turn(@game.active_color_clock.fen_to_color)
  end

  def announce_game_result
    if @game.is_stalemate?
      'the game has come to a stalemate'
    elsif @game.checkmate?
      announce_win(@game.active_color_clock.reverse_fen_color)
    elsif @game.move_repetitions == 3
      'the game has come to a draw as a result of repetetive movements'
    end
  end

  def announce_win(team_color)
    "#{team_color} Wins the game!"
  end

  def display_state_of_the_game
    reset_display
    announce_turn(@game.active_color_clock.fen_to_color)
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

  def reset_display
    system 'clear'
    @game.board_display.display_board
  end

  def announce_saved_game
    puts 'game has been saved'
  end

  def prompt_possible_movements
    puts 'This piece has the following movements available to it'
  end
end
