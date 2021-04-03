# frozen_string_literal: true

require_relative 'chess_pieces'
require_relative 'chess_board'
require_relative 'chess_game'
require 'pry'

a = Board.new
a.play_game

a = Board.new
a.place_starting_pieces
a.board_square([6, 0]).piece = a.empty_square([6, 0])
a.board_square([5, 0]).piece = a.empty_square([5, 0])
a.print_board
p a.castle?(a.board_square([4, 0]), a.board_square([7, 0]), 'king')
p a.castle?(a.board_square([4, 0]), a.board_square([0, 0]), 'queen')
a.board_square([1, 0]).piece = a.empty_square([1, 0])
a.board_square([2, 0]).piece = a.empty_square([2, 0])
a.board_square([3, 0]).piece = a.empty_square([3, 0])
p a.castle?(a.board_square([4, 0]), a.board_square([0, 0]), 'queen')

a = Board.new
a.place_starting_pieces
a.print_board
p a.board_square([2, 6]).piece.moved
a.print_board
p a.blocked?([1, 1], [3, 3])
p a.blocked?([7, 7], [2, 2])
a.print_board
p a.board_square([2, 1]).piece.moved
p k = a.find_king('white')
p a.knight_check?(k)
a.move_piece([1, 7], [3, 2])
p a.knight_check?(k)
p a.pawn_check?(k)
a.move_piece([6, 6], [3, 1])
p a.pawn_check?(k)
p a.adjacent_to_king?(k)
a.move_piece([4, 7], [3, 0])
p a.adjacent_to_king?(k)
a.print_board
a.board[1][3].piece = Bishop.new('black')
a.board[5][1].piece = Bishop.new('black')
a.print_board
p a.bishop_check?(k)
a.board[4][2].piece = Queen.new('black')
p a.rook_check?(k)
a.board[4][2].piece = Queen.new('black')
a.print_board
p a.board[1][1].piece.valid_moves([1, 1])
a.place_starting_pieces
a.print_board
a.board[1][2].piece = Pawn.new('black')
a.print_board
p a.legal_move?([3, 0], [0, 3])
p a.board[1][3]
p a.any_legal_moves?('white')
