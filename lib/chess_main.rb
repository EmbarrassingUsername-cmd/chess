require_relative 'chess_pieces.rb'
require_relative 'chess_board.rb'

a = Board.new
a.place_starting_pieces
a.print_board
p a.board[0][0].piece.valid_moves([0,0])
p a.board[1][0].piece.valid_moves([1,0])
p a.board[2][0].piece.valid_moves([2,0])
p a.board[3][0].piece.valid_moves([3,0])
p a.board[0][1].piece.valid_moves([0,1])
p a.board[0][6].piece.valid_moves([0,6])
p a.board[4][0].piece.valid_moves([4,0])
p a.board[5][0].piece.valid_moves([5,0])

