# frozen_string_literal: true

require_relative 'display/board_display'
require_relative 'display/game_display'
require_relative 'display/string'
require_relative 'pieces/piece_class'
require_relative 'path'
require_relative 'node'
require_relative 'location_conversion_module'
require_relative 'path_utilities_module'
require_relative 'movement_directions'
require_relative 'board'
require_relative 'movement_class'
require_relative 'pieces/piece_creation_module'
require_relative 'command_directions'
require_relative 'movement_clock'
require_relative 'move_logger'
require_relative 'active_color_clock'
require_relative 'command_interpreter'

class Game
  include Piece_creation
  include Path_utilities
  include Location_conversion
  attr_reader :en_passant, :movement, :active_color_clock, :board_display
  attr_accessor :board

  def initialize(board, movement_manager, active_color_clock, movement_clock)
    @board = board
    @board_display = Board_display.new(board)
    @movement_clock = movement_clock
    @movement = movement_manager
    @active_color_clock = active_color_clock
    @movement_logger = Move_logger.new(active_color_clock)
    @game_display = Game_display.new(self)
    @command_interpreter = Command_interpreter.new
  end

  def self_to_fen
    fen_string = "#{@board.self_to_fen} "
    fen_string += @movement.self_to_fen
    fen_string += @movement_clock.self_to_fen
  end

  def game_loop
    game_result_message = ''
    until is_game_over?
      @game_display.display_state_of_the_game
      until valid_piece_selection?(player_game_input = get_player_game_input)
        next unless @command_interpreter.is_a_command?(player_game_input)

        command_execution_results = @command_interpreter.execute_command(player_game_input)
        if command_execution_results.ends_the_game
          break
        else
          @game_display.reset_display
          puts command_execution_results.command_message
        end
      end
      if !command_execution_results.nil? && command_execution_results.ends_the_game
        game_result_message = command_execution_results.command_message
        break
      end
      game_turn(player_game_input)
    end
    @game_display.game_result_announcement(game_result_message)
  end

  def get_player_game_input
    @game_display.choose_piece_or_command_menu
    until valid_player_game_input?(player_game_input = gets.chomp)
      @game_display.reset_display
      @game_display.prompt_to_choose_piece_after_invalid_choice
    end
    player_game_input
  end

  def valid_player_game_input?(player_game_input)
    @command_interpreter.is_a_command?(player_game_input) || valid_piece_selection?(player_game_input)
  end
  def game_turn(piece_selection)
    movement_direction = get_movement_direction_from_player(piece_selection)
    will_capture = @movement.will_result_in_capture?(movement_direction)
    @movement.execute_movement_directions(movement_direction)
    convert_pawn(movement_direction) if movement_direction.will_convert

    @movement_clock.increment_full_turns if @active_color_clock.fen_to_color == 'black'

    if will_capture
      @movement_clock.reset_half_turns
    else
      @movement_clock.increment_half_turns
      @movement_logger.log_movement(movement_direction)
    end
    @active_color_clock.update_active_color
    @game_display.reset_display
  end

  def is_game_over?
    is_stalemate? || checkmate? || @movement_clock.fifty_move_rule?
  end

  def is_stalemate?
    current_color = @active_color_clock.fen_to_color
    kings_location = @board.find_king(current_color)
    result = false
    result = @movement.no_legal_movements_left? if @movement.is_square_under_attack?(kings_location.index) == false
    result
  end

  def would_players_like_to_draw?
    @game_display.reset_display
    if player_would_like_to_propose_draw?
      @game_display.reset_display
      result = player_agrees_to_a_draw?
    end
    reset_display
    result
  end

  def player_would_like_to_propose_draw?
    puts 'would you like to propose a draw Y/n'
    response = gets.chomp
    %w[Y y].include?(response)
  end

  def player_agrees_to_a_draw?
    puts 'Would you like to agree to draw?'
    response = gets.chomp
    %w[Y y].include?(response)
  end

  def convert_pawn(movement_direction)
    promotion_choice = get_player_promotion_selection
    piece_color = @active_color_clock.fen_to_color
    new_piece = create_piece(piece_color, promotion_choice)
    new_piece.moved
    @board.set_square_to(movement_direction.destination, new_piece)
  end

  def get_player_promotion_selection
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

  def get_movement_direction_from_player(piece_selection)
    movement_direction_array = movement_directions_from_piece_selection(piece_selection)
    movement_notations = get_movement_notation_from_piece_selection(piece_selection)
    @game_display.display_destinations(movement_notations)
    destination_selection = get_valid_destination_selection(movement_notations)
    movement_direction_index = get_direction_index_from_destination_selection(movement_notations, destination_selection)
    movement_direction_array[movement_direction_index]
  end

  def get_direction_index_from_destination_selection(notation_array, destination_selection)
    if destination_selection.numeric?
      destination_selection.to_i
    else
      notation_array.index(destination_selection)
    end
  end

  def get_movement_notation_from_piece_selection(piece_selection)
    movement_direction_array = movement_directions_from_piece_selection(piece_selection)
    movement_directions_to_notation(movement_direction_array)
  end

  def movement_directions_from_piece_selection(piece_selection)
    piece_location = selection_to_location(piece_selection)
    @movement.get_possible_movement_directions(piece_location)
  end

  def get_valid_destination_selection(notation_array)
    destination_count = notation_array.length - 1
    @game_display.prompt_to_choose_destination
    until valid_destination_selection?(choice = gets.chomp, notation_array)
      @game_display.promt_to_choose_destination_after_invalid_choice
    end
    choice
  end

  def valid_destination_selection?(destination_choice, notation_array)
    destination_count = notation_array.length - 1
    if is_notation?(destination_choice)
      notation_array.include?(destination_choice)
    elsif destination_choice.numeric?
      result = destination_choice.to_i.between?(0, destination_count) if destination_choice.match?(/[[:digit:]]/)
    else
      false
    end
  end

  def movement_directions_to_notation(movement_direction_array)
    destination_array = movement_directions_to_destinations(movement_direction_array)
    notation_array = destinations_to_notation(destination_array)
  end

  def movement_directions_to_destinations(movement_direction_array)
    destination_array = []
    movement_direction_array.each do |movement_direction|
      destination_array << movement_direction.destination
    end
    destination_array
  end

  def destinations_to_notation(destination_array)
    notation_array = []
    destination_array.each do |destination|
      notation_array << location_to_selection(destination)
    end
    notation_array
  end

  def checkmate?
    @movement.no_legal_movements_left?
  end

  def valid_piece_selection?(selection)
    result = false
    if is_notation?(selection)
      location = selection_to_location(selection)
      if valid_location?(location) && (!@board.empty_location?(location) && (@board.get_value_of_square(location).team == @active_color_clock.fen_to_color)) && @movement.can_piece_move?(location)
        result = true
      end
    end
    result
  end

  def is_notation?(selection)
    result = false
    if selection.length == 2
      selection = selection.chars
      result = true if is_a_letter?(selection.first) && selection.last.numeric?
    end
    result
  end

  def is_a_letter?(character)
    character.match?(/[a-h]/)
  end
end
