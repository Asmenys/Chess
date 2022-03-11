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
require_relative 'command_directions'
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

  def save_game
    create_save_dir unless does_save_dir_exist?
    File.open("saves/#{get_file_name}", 'w') {|save_file| save_file.write("#{self_to_fen}")}
  end

  def does_save_dir_exist?
    Dir.exist?('saves/')
  end

  def get_file_name
    "saved_game_#{get_file_name_index}"
  end

  def create_save_dir
    Dir.mkdir('saves/')
  end

  def get_file_name_index
    Dir.glob('saves/**').length.to_s
  end

  def self_to_fen
    fen_string = "#{@board.board_to_fen} "
    fen_string += @movement.self_to_fen
    fen_string += "#{@half_turn} "
    fen_string += @full_turns.to_s
  end

  def game_loop
    player_chose_to_end_the_game = false
    until is_game_over? || player_chose_to_end_the_game
      reset_display
      until valid_piece_selection?(player_game_input = get_player_game_input)
        'not implemented' if is_a_command?(player_game_input)
      end
      game_turn(player_game_input)
    end
    announce_game_result
  end

  def get_player_game_input
    choose_piece_or_command_menu
    until valid_player_game_input?(player_game_input = gets.chomp)
      reset_display
      prompt_to_choose_piece_after_invalid_choice
    end
    player_game_input
  end

  def valid_player_game_input?(player_game_input)
    is_a_command?(player_game_input) || valid_piece_selection?(player_game_input)
  end

  def is_a_command?(player_game_input)
    %w[save draw resign].include?(player_game_input.downcase)
  end

  def execute_command(command)
    command_result_message = ''
    command_direction = Command_directions.new
    case command
    when 'save'
      save_game
      command_direction.command_message = announce_saved_game
    when 'draw'
      if player_agrees_to_a_draw?
        command_direction.ends_the_game = true
        command_direction.command_message = 'Players have agreed to a draw'
      end
    when 'resign'
      command_direction.command_message = 'Player has resigned from the game'
      command_direction.ends_the_game = true
    end
    command_direction
  end

  def game_turn(piece_selection)
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
    if repetetive_movement?(movement_destination)
      @move_repetitions += 1
    else
      @move_repetitions = 0
    end
  end

  def repetetive_movement?(movement_destination)
    case @movement.fen_to_color
    when 'black'
      begin
        movement_destination == @last_move_black
      rescue StandardError
        false
      end
    when 'white'
      begin
        movement_destination == @last_move_white
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
      if valid_location?(location) && (!@board.empty_location?(location) && (@board.get_value_of_square(location).team == @movement.fen_to_color)) && can_piece_move?(selection)
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
