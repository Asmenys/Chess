# frozen_string_literal: true

require 'pry-byebug'
class Movement
  attr_reader :board

  def initialize(board, active_color, en_passant)
    @board = board
    @active_color = active_color
    @en_passant = en_passant
  end

  def is_square_friendly?(square_location)
    square_value = @board.get_value_of_square(square_location)
    if square_value.nil?
      false
    else
      square_value.team == fen_to_color
    end
  end

  def fen_to_color
    color_hash = { 'white' => 'w', 'black' => 'b' }
    color_hash.key(@active_color)
  end

  def would_leave_king_in_check?(from, to)
    stored_board = @board
    board_clone = @board.clone
    @board = board_clone
    move_piece(from, to)
    result = is_king_in_check?
    @board = stored_board
    result
  end

  def move_piece(from, to)
    piece = @board.get_value_of_square(from)
    @board.set_square_to(from, nil)
    @board.set_square_to(to, piece)
  end

  def get_pawn_location_from_en_passant
    case @active_color
    when 'w'
      [@en_passant[0] + 1, @en_passant[1]]
    when 'b'
      [@en_passant[0] - 1, @en_passant[1]]
    end
  end

  def is_king_in_check?
    kings_node = @board.find_king(fen_to_color)
    is_square_under_attack?(kings_node.index)
  end

  def is_square_under_attack?(square_location)
    attack_paths = @board.node_attack_paths(square_location)
    earliest_piece_nodes = get_earliest_piece_nodes_from_paths(attack_paths)
    earliest_piece_nodes = filter_out_friendly_nodes(earliest_piece_nodes)
    is_under_attack = can_pieces_move_to?(earliest_piece_nodes, square_location)
  end

  def can_pieces_move_to?(piece_nodes, movement_destination)
    can_move_to = false
    piece_nodes.each do |piece_node|
      piece = piece_node.value
      piece_location = piece_node.index
      if piece.possible_paths(piece_location).any? { |path| path.include?(movement_destination) }
        can_move_to = true
        break
      end
    end
    can_move_to
  end

  def filter_out_friendly_nodes(node_array)
    node_array.delete_if { |node| node.value.team == fen_to_color }
    node_array
  end

  def get_earliest_piece_nodes_from_paths(paths)
    earliest_piece_nodes = []
    paths.each do |path|
      earliest_piece_node = path.get_earliest_piece_node
      earliest_piece_nodes << earliest_piece_node unless earliest_piece_node.nil? || earliest_piece_node.value.nil?
    end
    earliest_piece_nodes
  end
end
