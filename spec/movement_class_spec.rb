# frozen_string_literal: true

require 'load_game'
describe Movement do
  describe '#filter_movements_for_check' do
    it 'given an array of movements, filters out those that would leave the king in check.' do
      game = Load_game.new('7k/8/8/5b2/8/8/8/1KP5 w - - 0 1').game
      movement_array = [[6, 2], [5, 2]]
      current_location = [7, 2]
      expect(game.movement.filter_movements_for_check(current_location, movement_array)).to eq [[6, 2]]
    end
    it 'when all of moves leave the king in check, no moves are returnd' do
      game = Load_game.new('8/8/8/5b2/8/3P4/2K5/8 w - - 0 1').game
      current_location = [5, 3]
      movement_array = [[4, 3], [3, 3]]
      expect(game.movement.filter_movements_for_check(current_location, movement_array)).to eq []
    end
    it 'when king is in check returns only a movement that places the king out of check' do
      game = Load_game.new('2r5/8/8/8/8/7R/2K5/8 w - - 0 1').game
      current_location = [5, 7]
      movement_array = [[5, 6], [5, 5], [5, 4], [5, 3], [5, 2], [5, 1], [5, 0]]
      expect(game.movement.filter_movements_for_check(current_location, movement_array)).to eq [[5, 2]]
    end
  end
  describe '#is_square_friendly?' do
    it 'returns true when square holds a piece of same color as the current active colour' do
      square_loc = [4, 3]
      game = Load_game.new('8/8/8/8/3P4/8/8/8 w - - 0 1').game
      expect(game.movement.is_square_friendly?(square_loc)).to be true
    end
    it 'false when square holds a piece of unequal color' do
      current_loc = [4, 3]
      game = Load_game.new('8/8/8/8/3p4/8/8/8 w - - 0 1').game
      expect(game.movement.is_square_friendly?(current_loc)).to be false
    end
    it 'when square is empty returns false' do
      current_loc = [4, 3]
      current_piece = Pawn.new('white', 'Pawn')
      game = Load_game.new('8/8/8/8/8/8/8/8 w - - 0 1').game
      expect(game.movement.is_square_friendly?(current_loc)).to be false
    end
  end
  describe '#is_square_under_attack?' do
    context 'given a squares location, returns a bool based on whether its under attack or not' do
      it 'when not under attack returns false' do
        game = Load_game.new('8/8/8/8/8/8/8/8 w - - 0 1').game
        square_loc = [4, 3]
        expect(game.movement.is_square_under_attack?(square_loc)).to be false
      end
      it 'when it is under attack returns true' do
        game = Load_game.new('8/8/8/8/8/3P4/8/8 b - - 0 1').game
        square_loc = [4, 3]
        expect(game.movement.is_square_under_attack?(square_loc)).to be true
      end
    end
  end
  describe '#would_leave_king_in_check?' do
    context 'returns a bool based on whether the move leaves own players king in check' do
      it 'when a pawn moves leaving the king in check for a bishop return true' do
        game = Load_game.new('8/8/8/4b3/3P4/2K5/8/8 w - - 0 1').game
        current_loc = [4, 3]
        destination_loc = [3, 3]
        expect(game.movement.would_leave_king_in_check?(current_loc, destination_loc)).to be true
      end
      it 'when a pawn moves but the king is not left in check for a bishop' do
        game = Load_game.new('8/8/8/4b3/8/2KP4/8/8 w - - 0 1').game
        current_loc = [5, 3]
        destination_loc = [4, 3]
        expect(game.movement.would_leave_king_in_check?(current_loc, destination_loc)).to be false
      end
    end
  end
  describe '#move_piece' do
    it 'moves a piece from a given location to another given location' do
      current_loc = [4, 3]
      destination = [4, 5]
      game = Load_game.new('8/8/8/8/3P4/8/8/8 w - - 0 1').game
      game.movement.move_piece(current_loc, destination)
      expect(game.board.get_value_of_square(current_loc)).to be nil
      expect(game.board.empty_location?(destination)).to be false
    end
  end
  describe '#get_pawn_location_from_en_passant' do
    it 'when @en_passant is e6 and active color is white returns [3, 4]' do
      game = Load_game.new('8/8/8/4p3/8/8/8/8 w - e6 0 1').game
      expect(game.movement.get_pawn_location_from_en_passant).to eq [3, 4]
    end
    it 'when @en_passant is e3 and active color is black returns [5, 4]' do
      game = Load_game.new('8/8/8/8/4P3/8/8/8 b - e3 0 1').game
      expect(game.movement.get_pawn_location_from_en_passant).to eq [4, 4]
    end
  end
  describe '#is_king_in_check?' do
    context 'given kings location, checks if the king is compromised' do
      it 'when king is in check returns true' do
        fen_string = '8/8/8/8/3k4/8/3R4/8 b - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.movement.is_king_in_check?).to be true
      end
      it 'when king is not in check returns false' do
        fen_string = '8/8/8/8/3k4/8/3B4/8 b - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.movement.is_king_in_check?).to be false
      end
      it 'when theres a knight keeping the king in check return true' do
        fen_string = '8/8/8/8/3kp3/3pp3/4N3/8 b - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.movement.is_king_in_check?).to be true
      end
      it 'when king is not in check but a friendly piece includes the king in its possible paths returns false' do
        fen_string = '8/8/4N3/8/3K4/8/8/8 w - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.movement.is_king_in_check?).to be false
      end
      it 'returns false when surrounded by friendly pieces that all include king in their paths' do
        fen_string = '8/8/2nq4/8/2rk4/3p4/5b2/8 b - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.movement.is_king_in_check?).to be false
      end
      it 'true when surrounded by friendly pieces but under attack' do
        fen_string = '8/8/2nq4/4pN2/2rkp3/3p4/5b2/8 b - - 0 1'
        game_instance = Load_game.new(fen_string).game
        expect(game_instance.movement.is_king_in_check?).to be true
      end
    end
  end
  describe '#get_earliest_piece_nodes_from_paths' do
    it 'given an array of paths, returns an array of earliest encountered pieces in each path' do
      game = Load_game.new.game
      generic_piece_containing_node = Node.new([5, 5], 'i contain a piece wooo god damn hooo')
      path_uno = Path.new([Node.new([4, 3]), Node.new([4, 4]), generic_piece_containing_node])
      path_dos = Path.new([Node.new([4, 4]), Node.new([4, 5])])
      generic_piece_containing_node_dos = Node.new([2, 4], 'piece two yay')
      path_tres = Path.new([Node.new([2, 2]), Node.new([2, 3]), generic_piece_containing_node_dos])
      expected_array_result = [generic_piece_containing_node, generic_piece_containing_node_dos]
      expect(game.movement.get_earliest_piece_nodes_from_paths([path_uno, path_dos,
                                                                path_tres])).to eq expected_array_result
    end
  end
  describe '#filter_out_friendly_nodes' do
    it 'given an array of nodes, removes nodes that match the current active color' do
      game = Load_game.new('8/8/8/8/8/8/8/8 w - - 0 1').game
      node_one = Node.new([4, 3], Pawn.new('white', 'Pawn'))
      node_two = Node.new([5, 4], Pawn.new('black', 'Pawn'))
      node_array = [node_one, node_two]
      expected_array_result = [node_two]
      expect(game.movement.filter_out_friendly_nodes(node_array)).to eq expected_array_result
    end
  end
  describe '#fen_to_color' do
    context 'converts the active fen color to a color used by other functions' do
      it 'when current color is w returns white' do
        game = Load_game.new.game
        expect(game.movement.fen_to_color).to eq 'white'
      end
      it 'when current color is b returns black' do
        game = Load_game.new('8/8/8/8/8/8/8/8 b - - 0 1').game
        expect(game.movement.fen_to_color).to eq 'black'
      end
    end
  end
  describe '#can_pieces_move_to?' do
    context 'given a populated node array and a final mov. destination checks if any pieces can move to such destination' do
      let(:game) { Load_game.new.game }
      it 'when doesnt include returns false' do
        movement_destination = [7, 7]
        node_array = [Node.new([4, 3], Pawn.new('white', 'Pawn'))]
        expect(game.movement.can_pieces_move_to?(node_array, movement_destination)).to be false
      end
      it 'when includes returns true' do
        movement_destination = [7, 7]
        node_array = [Node.new([6, 7], Pawn.new('black', 'Pawn'))]
        expect(game.movement.can_pieces_move_to?(node_array, movement_destination)).to be true
      end
    end
  end
end
