# frozen_string_literal: true

require_relative 'chess_pieces'
require_relative 'chess_board'
require_relative 'chess_game'

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
a.print_board
