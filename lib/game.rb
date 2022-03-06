# frozen_string_literal: true

require_relative 'display/display'
require_relative 'display/string'
require_relative 'pieces/piece_class'
require_relative 'path'
require_relative 'node'
require_relative 'location_conversion_module'
require_relative 'path_utilities_module'
require_relative 'movement_directions'
require_relative 'board'
require_relative 'movement_class'
require_relative 'piece_creation_module'
class Game
  include Piece_creation
  include Display
  include Path_utilities
  include Location_conversion
  attr_reader :full_turns, :half_turn, :en_passant, :active_color, :movement
  attr_accessor :board

  def initialize(board, movement_manager, full_turn = nil, half_turn = nil)
    @board = board
    @full_turns = full_turn
    @half_turn = half_turn
    @movement = movement_manager
    @move_repetitions = 0
    @last_move_white = nil
    @last_move_black = nil
  end

  def game_loop
    game_result_message = ''
    game_turn until is_game_over?
    if is_stalemate?
      game_result_message 'the game has come to a stalemate'
    elsif has_player_lost?
      game_result_message = announce_win(reverse_fen_color)
    elsif @move_repetitions == 3
      game_result_message = 'the game has come to a draw as a result of repetetive movements'
    else
      game_result_message = 'Players have agreed to a draw'
    end
    game_result_message
  end

  def is_game_over?
    is_stalemate? || has_player_lost? || @half_turn >= 50 || would_players_like_to_draw?
  end

  def is_stalemate?
    current_color = @movement.fen_to_color
    kings_location = @board.find_king(current_color)
    result = false
    result = no_legal_movements_left? if @movement.is_square_under_attack?(kings_location.index) == false
    result
  end

  def game_turn
    reset_display
    announce_turn(@movement.fen_to_color)
    piece_selection = get_player_piece_selection
    movement_direction = get_movement_direction_from_player(piece_selection)
    will_capture = @movement.will_result_in_capture?(movement_direction)
    @movement.execute_movement_directions(movement_direction)
    convert_pawn(movement_direction) if movement_direction.will_convert

    increment_full_turns if @movement.fen_to_color == 'black'

    if will_capture
      reset_half_turns
    else
      increment_half_turns
    end
    @movement.update_active_color
  end

  def would_players_like_to_draw?
    reset_display
    if player_would_like_to_propose_draw?
      reset_display
      result = player_agrees_to_a_draw?
    end
    reset_display
    result
  end

  def player_would_like_to_propose_draw?
    puts 'would you like to propose a draw Y/n'
    respone = gets.chomp
    %w[Y y].include?(respone)
  end

  def player_agrees_to_a_draw?
    puts 'Would you like to agree to draw?'
    response = gets.chomp
    %w[Y y].include?(respone)
  end

  def update_repetitions(movement_direction)
    movement_destination = movement_direction.destination
    if repetetive_movement?(movement_direction)
      @move_repetitions += 1
    else
      @move_repetitions = 0
    end
  end

  def repetetive_movement?(_movement_destination)
    case @movement.fen_to_color
    when 'black'
      begin
        destination == @last_move_black
      rescue StandardError
        false
      end
    when 'white'
      begin
        destination == @last_move_white
      rescue StandardError
        false
      end
    end
  end

  def log_movement(movement_direction)
    unless will_result_in_capture?(movement_direction)
      if @movement.fen_to_color == 'black'
        @last_move_black = movement_direction.current_location
      else
        @last_move_white = movement_direction.current_location
      end
    end
  end

  def convert_pawn(movement_direction)
    promotion_choice = get_player_promotion_selection
    piece_color = @movement.fen_to_color
    new_piece = create_piece(piece_color, promotion_choice)
    new_piece.moved
    @board.set_square_to(movement_direction.destination, new_piece)
  end

  def get_player_promotion_selection
    promt_to_choose_promotion
    until valid_promotion_selection?(choice = gets.chomp)
      promt_to_choose_promotion_after_invalid
    end
    choice
  end

  def valid_promotion_selection?(choice)
    valid_conversions = %w[Rook Queen Knight Bishop]
    valid_conversions.include?(choice)
  end

  def get_player_piece_selection
    piece_selection = nil
    can_piece_move = false
    until can_piece_move
      piece_selection = get_valid_piece_selection
      can_piece_move = can_piece_move?(piece_selection)
      reset_display
      prompt_immovable_piece unless can_piece_move
    end
    piece_selection
  end

  def can_piece_move?(piece_selection)
    available_moves = get_movement_notation_from_piece_selection(piece_selection)
    !available_moves.empty?
  end

  def reverse_fen_color
    if @movement.fen_to_color == 'black'
      'white'
    else
      'black'
    end
  end

  def get_movement_direction_from_player(piece_selection)
    movement_direction_array = movement_directions_from_piece_selection(piece_selection)
    movement_notations = get_movement_notation_from_piece_selection(piece_selection)
    display_destinations(movement_notations)
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

  def get_valid_piece_selection
    promt_to_choose_piece
    until valid_piece_selection?(selection = get_piece_selection)
      reset_display
      prompt_to_choose_piece_after_invalid_choice
    end
    selection
  end

  def get_valid_destination_selection(notation_array)
    destination_count = notation_array.length - 1
    prompt_to_choose_destination
    until valid_destination_selection?(choice = gets.chomp, notation_array)
      promt_to_choose_destination_after_invalid_choice
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

  def get_piece_selection
    selection = gets.chomp
  end

  def has_player_lost?
    no_legal_movements_left?
  end

  def increment_full_turns
    @full_turns += 1
  end

  def increment_half_turns
    @half_turn += 1
  end

  def reset_half_turns
    @half_turn = 0
  end

  def valid_piece_selection?(selection)
    result = false
    if is_notation?(selection)
      location = selection_to_location(selection)
      if valid_location?(location) && (!@board.empty_location?(location) && (@board.get_value_of_square(location).team == @movement.fen_to_color))
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

  def no_legal_movements_left?
    piece_location_array = @board.get_piece_locations_of_color(@movement.fen_to_color)
    result = true
    piece_location_array.each do |piece_location|
      unless @movement.get_possible_movement_directions(piece_location).empty?
        result = false
        break
      end
    end
    result
  end
end
