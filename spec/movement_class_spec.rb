# frozen_string_literal: true

require 'load_game'
describe Movement do
  describe '#get_possible_movement_directions' do
    context 'returns directions for all the possible legal movements a piece may take' do
      black_move_test_game = Load_game.new('5Rpk/1n3B1p/8/2Pp4/8/8/2P5/R2K3R b - - 0 1').game
      white_move_test_game = Load_game.new('5Rpk/1n3B1p/8/2Pp4/8/8/2P5/R2K3R w - d6 0 1').game
      it 'black pawn without any legal moves returns an empty array' do
        black_pawn_location = [0, 6]
        expect(black_move_test_game.movement.get_possible_movement_directions(black_pawn_location).empty?).to be true
      end
      it 'black knight has 4 legal moves' do
        black_knight_location = [1, 1]
        expect(black_move_test_game.movement.get_possible_movement_directions(black_knight_location).length).to eq 4
      end
      it 'black pawn has 2 legal moves' do
        black_pawn_with_moves_location = [1, 7]
        expect(black_move_test_game.movement.get_possible_movement_directions(black_pawn_with_moves_location).length).to eq 2
      end
      it 'white pawn has 3 possible moves' do
        white_pawn_location = [3, 2]
        expect(white_move_test_game.movement.get_possible_movement_directions(white_pawn_location).length).to eq 3
      end
      it 'white pawn may capture a black en_passant' do
        white_pawn_location = [3, 2]
        white_pawn_movement_directions = white_move_test_game.movement.get_possible_movement_directions(white_pawn_location)
        en_passant_capture_direction = white_pawn_movement_directions.last
        commit_capture = white_move_test_game.movement.execute_movement_directions(en_passant_capture_direction)
        expected_pawn_result_location = [2, 3]
        expect(white_move_test_game.board.get_value_of_square(expected_pawn_result_location).class).to be Pawn
        black_pawn_location = [3, 3]
        expect(white_move_test_game.board.get_value_of_square(black_pawn_location)).to be nil
      end
      context 'returns all possible destinations for white rook' do
        white_rook_location = [7, 0]
        possible_movement_directions = white_move_test_game.movement.get_possible_movement_directions(white_rook_location)
        it 'returns 10 possible movements' do
          expect(possible_movement_directions.length).to eq 10
        end
      end
    end
  end

  describe '#get_pawn_captures' do
    context 'given a pawns location returns movement directions for possible captures diagonaly' do
      game_with_one_move = Load_game.new('8/8/8/4b3/3P4/8/8/8 w - - 0 1').game
      pawn_location = [4, 3]
      game_without_captures = Load_game.new('8/8/8/3p4/3P4/8/8/8 w - - 0 1').game
      pawn_without_captures = [4, 3]
      black_pawn_with_captures = Load_game.new('8/8/8/3p4/4R3/8/8/8 b - - 0 1').game
      black_pawn_location = [3, 3]
      it 'generates one movement_direction' do
        expect(game_with_one_move.movement.get_pawn_captures(pawn_location).length).to eq 1
      end
      it 'executing the movement direction removes the enemy pawn and moves current pawn' do
        movement_direction = game_with_one_move.movement.get_pawn_captures(pawn_location)
        game_with_one_move.movement.execute_movement_directions(movement_direction.first)
        expect(game_with_one_move.board.get_value_of_square(pawn_location)).to be nil
        expect(game_with_one_move.board.get_value_of_square([3, 4]).class).to be Pawn
      end
      it 'when there are no possible captures returns an empty array' do
        expect(game_without_captures.movement.get_pawn_captures(pawn_without_captures).empty?).to be true
      end
      it 'generates one movement dir for a black pawn' do
        expect(black_pawn_with_captures.movement.get_pawn_captures(black_pawn_location).length).to eq 1
      end
      it 'executing black_pawns movement dir yields expected results' do
        expected_result_location = [4, 4]
        movement_direction = black_pawn_with_captures.movement.get_pawn_captures(black_pawn_location).first
        black_pawn_with_captures.movement.execute_movement_directions(movement_direction)
        expect(black_pawn_with_captures.board.get_value_of_square(expected_result_location).class).to be Pawn
        expect(black_pawn_with_captures.board.get_value_of_square(black_pawn_location)).to be nil
      end
    end
  end

  describe '#get_castling' do
    context 'given location of a piece, returns movement directions for castling' do
      game = Load_game.new('8/8/8/8/8/8/8/R2K3R w - - 0 1').game
      current_loc = [7, 3]
      it 'returns 2 movement direction objects' do
        expect(game.movement.get_castling(current_loc).length).to eq 2
      end
      it 'executing movement directions would move pieces correctly' do
        movement_directions = game.movement.get_castling(current_loc)
        game.movement.execute_movement_directions(movement_directions.first)
        expect(game.board.get_value_of_square([7, 0]).instance_of?(King)).to be true
        expect(game.board.get_value_of_square([7, 3]).instance_of?(Rook)).to be true
      end
    end
  end
  describe '#get_two_step' do
    it 'given a location of a pawn, returns movement directions for en_passant or nil if the move cant be performed' do
      game = Load_game.new('8/8/8/8/8/8/1P6/8 w - - 0 1').game
      current_location = [6, 1]
      two_step_directions = game.movement.get_two_step(current_location).first
      expect(two_step_directions.en_passant).to eq [5, 1]
      expect(two_step_directions.destination).to eq [4, 1]
    end
  end
  describe '#get_generic_movements' do
    it 'given piece node returns all possible legal movements of the piece' do
      game = Load_game.new('3p4/8/8/3r2P1/3P4/8/8/8 b - - 0 1').game
      piece_location = [3, 3]
      expected_index_array = [[4, 3], [2, 3], [1, 3], [3, 2], [3, 1], [3, 0], [3, 4], [3, 5], [3, 6]]
      movement_direction_array = game.movement.get_generic_movements(piece_location)
      expect(movement_direction_array.length).to eq expected_index_array.length
      expect(movement_direction_array.all? { |mov_dir| mov_dir.instance_of?(Movement_directions) }).to be true
    end
  end

  describe '#remove_friendly_destinations' do
    it 'given a path that ends with a friendly node removes the node from the path' do
      path = Path.new([Node.new([4, 3]), Node.new([4, 4]), Node.new([4, 5], Pawn.new('white', 'Pawn'))])
      game = Load_game.new('8/8/8/8/8/8/8/8 w - - 0 1').game
      result_path = game.movement.remove_friendly_destinations([path])
      expect(result_path[0].last_node.empty?).to be true
    end
  end

  describe '#movement_directions_from_location_index_array' do
    subject(:game) { Load_game.new('8/8/8/8/8/8/8/8 w - - 0 1').game }
    it 'given an array of node indexes returns an array of movement directions' do
      node_index_array = [[5, 4], [5, 3], [5, 2], [5, 1]]
      current_location = [3, 2]
      mov_dir_array = game.movement.movement_directions_from_location_index_array(current_location,
                                                                                  node_index_array)
      expect(mov_dir_array.length).to eq node_index_array.length
      expect(mov_dir_array.all? { |mov_dir| mov_dir.instance_of?(Movement_directions) }).to be true
    end
  end
  describe '#movement_directions_from_location_index' do
    subject(:game) { Load_game.new('8/8/8/8/8/8/8/8 w - - 0 1').game }
    it 'returns a new Movement_directions object from given values' do
      starting_loc = [4, 3]
      destination = [5, 3]
      movement_directions_object = game.movement.movement_directions_from_location_index(starting_loc, destination)
      expect(movement_directions_object.class).to be Movement_directions
      expect(movement_directions_object.moves_two_pieces?).to be false
      expect(movement_directions_object.creates_en_passant?).to be false
    end
  end
  describe '#filter_movements_for_check' do
    it 'given an array of movements, filters out those that would leave the king in check.' do
      game = Load_game.new('7k/8/8/5b2/8/8/8/1KP5 w - - 0 1').game
      movement_array = [[6, 2], [5, 2]]
      current_location = [7, 2]
      movement_direction_array = game.movement.movement_directions_from_location_index_array(current_location,
                                                                                             movement_array)
      expect(game.movement.filter_movements_for_check(movement_direction_array).first.destination).to eq [6, 2]
    end
    it 'when all of moves leave the king in check, no moves are returnd' do
      game = Load_game.new('8/8/8/5b2/8/3P4/2K5/8 w - - 0 1').game
      current_location = [5, 3]
      movement_array = [[4, 3], [3, 3]]
      movement_direction_array = game.movement.movement_directions_from_location_index_array(current_location,
                                                                                             movement_array)
      expect(game.movement.filter_movements_for_check(movement_direction_array)).to eq []
    end
    it 'when king is in check returns only a movement that places the king out of check' do
      game = Load_game.new('2r5/8/8/8/8/7R/2K5/8 w - - 0 1').game
      current_location = [5, 7]
      movement_array = [[5, 6], [5, 5], [5, 4], [5, 3], [5, 2], [5, 1], [5, 0]]
      movement_direction_array = game.movement.movement_directions_from_location_index_array(current_location,
                                                                                             movement_array)
      expect(game.movement.filter_movements_for_check(movement_direction_array).first.destination).to eq [5, 2]
    end
  end
  describe '#paths_until_first_piece_from_path_array' do
    context 'given an array of paths, returns an array of paths until the first encountered object' do
      game = Load_game.new('8/8/8/8/2PR2p1/8/3P4/8 w - - 0 1').game
      rook = Rook.new('white', 'Rook')
      array_of_paths = game.board.array_of_path_node_indexes_to_paths(rook.possible_paths([4, 3]))
      array_of_paths_until_first_piece = game.movement.paths_until_first_piece_from_path_array(array_of_paths)
      it 'returns 4 paths until first encountered objects' do
        expect(array_of_paths_until_first_piece.length).to eq array_of_paths.length
      end
      it 'last nodes in paths are either empty, or contain enemy pieces' do
        expect(array_of_paths_until_first_piece[0].last_node.value.team).to eq 'white'
        expect(array_of_paths_until_first_piece[1].last_node.value).to be nil
        expect(array_of_paths_until_first_piece[2].last_node.value.team).to eq 'white'
        expect(array_of_paths_until_first_piece[3].last_node.value.team).to eq 'black'
      end
    end
  end
  describe '#remove_friendly_destinations' do
    context 'given an array of paths, returns an array of paths until first enemy object, or empty node' do
      game = Load_game.new('8/8/8/8/2PR2p1/8/3P4/8 w - - 0 1').game
      rook = Rook.new('white', 'Rook')
      array_of_paths = game.board.array_of_path_node_indexes_to_paths(rook.possible_paths([4, 3]))
      array_of_paths_until_first_piece = game.movement.paths_until_first_piece_from_path_array(array_of_paths)
      array_of_paths_until_friendly_pieces = game.movement.remove_friendly_destinations(array_of_paths_until_first_piece)
      it 'returns 4 paths' do
        expect(array_of_paths_until_friendly_pieces.length).to eq 4
      end
      it 'none of the paths include a friendly piece' do
        last_node_values = []
        array_of_paths_until_friendly_pieces.each do |path|
          last_node_values << path.last_node.value unless path.empty?
        end
        last_node_values.compact!
        expect(last_node_values.none? { |value| value.team == rook.team })
      end
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
        destination = [3, 3]
        movement_directions = Movement_directions.new(current_loc, destination)
        expect(game.movement.would_leave_king_in_check?(movement_directions)).to be true
      end
      it 'when a pawn moves but the king is not left in check for a bishop' do
        game = Load_game.new('8/8/8/4b3/8/2KP4/8/8 w - - 0 1').game
        current_loc = [5, 3]
        destination = [4, 3]
        movement_directions = Movement_directions.new(current_loc, destination)
        expect(game.movement.would_leave_king_in_check?(movement_directions)).to be false
      end
    end
  end
  describe '#move_piece' do
    it 'moves a piece from a given location to another given location' do
      current_loc = [4, 3]
      destination = [4, 5]
      movement_directions = Movement_directions.new(current_loc, destination)
      game = Load_game.new('8/8/8/8/3P4/8/8/8 w - - 0 1').game
      game.movement.move_piece(movement_directions)
      expect(game.board.empty_location?(destination)).to be false
    end
  end
  describe '#delete_moved_pieces' do
    it 'deletes pieces on current_location index' do
      movement_directions = Movement_directions.new([4, 3], [5, 5])
      game = Load_game.new('8/8/8/8/3P4/5P2/8/8 w - - 0 1').game
      game.movement.delete_moved_pieces(movement_directions)
      expect(game.board.get_value_of_square(movement_directions.current_location)).to be nil
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
  describe '#path_indexes_to_paths' do
    context 'given an array of paths as node indexes returns an array of paths' do
      game = Load_game.new.game
      array_of_path_indexes = [[[5, 5]],
                               [[5, 1]],
                               [[6, 4]],
                               [[6, 2]],
                               [[2, 2]],
                               [[2, 4]],
                               [[3, 5]],
                               [[3, 1]]]
      array_of_paths = game.movement.path_indexes_to_paths(array_of_path_indexes)
      it 'the array is of appropriate length' do
        expect(array_of_paths.length).to eq array_of_path_indexes.length
      end
      it 'each of the paths contain appropriate nodes' do
        path_nodes = []
        array_of_paths.each do |path|
          path_nodes << path.nodes_as_indexes
        end
        expect(path_nodes).to eq array_of_path_indexes
      end
    end
  end
end
