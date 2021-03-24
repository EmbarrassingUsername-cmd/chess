# frozen_string_literal: true

# Methods relating to game logic moving pieces check and checkmate
module Game
  def move_piece(position, moving_to)
    initial_piece = board_square(position).piece
    board_square(moving_to).piece = initial_piece
    board_square(position).piece = empty_square(position)
    initial_piece.moved = true if initial_piece.instance_of? Pawn
  end

  def legal_move?(position, moving_to)
    return false unless board_square(position).valid_moves(position).include?(moving_to)
    return false if blocked?(position, moving_to)
    return false if king_checked?(position, moving_to)
    return false if board_square(position).piece.colour == board_square(moving_to).piece.colour

    true
  end

  def blocked?(position, moving_to)
    translation = [moving_to, position].transpose.map { |x, y| x - y }
    maximum = translation.map(&:abs).max
    step = translation.map { |i| i / maximum }
    intermediate_squares = (1.upto(maximum - 1).map do |i|
      [position, step.map { |value| value * i }].transpose.map(&:sum)
    end)
    contains_piece?(intermediate_squares)
  end

  def contains_piece?(array)
    array.any? { |position| board_square(position).piece.class.superclass == Piece }
  end

  def king_checked?(position, moving_to)
    temp = @board.dup
    temp.move_piece(position, moving_to)
    king = find_king(board_square(moving_to).piece.colour)
    return true if knight_check?(king)
    return true if pawn_check?(king)
    return true if bishop_check?(king)
    return true if rook_check?(king)
    return true if adjacent_to_king?(king)
  end

  def find_king(colour)
    @board.each do |column|
      column.each do |square|
        return square if (square.piece.instance_of? King) && (square.piece.colour == colour)
      end
    end
  end

  def knight_check?(king)
    squares = king.piece.valid_moves_knight(king.position).map { |square| board_square(square) }
    squares.each do |square|
      return true if (square.piece.instance_of? Knight) && (square.piece.colour != king.piece.colour)
    end
    false
  end

  def pawn_check?(king)
    positions = king.piece.colour == 'white' ? [[1, 1], [-1, 1]] : [[-1, -1], [1, -1]]
    positions.each do |translation|
      square = board_square([translation, king.position].transpose.map(&:sum))
      return true if (square.piece.instance_of? Pawn) && (square.piece.colour != king.piece.colour)
    end
    false
  end

  def adjacent_to_king?(king)
    squares = king.piece.valid_moves_king(king.position).map { |square| board_square(square) }
    squares.each do |square|
      return true if square.piece.instance_of? King
    end
    false
  end

  def bishop_check?(king)
    squares = king.piece.valid_moves_bishop(king.position).map { |square| board_square(square) }
    pieces_in_line = []
    squares.each do |square|
      if ([Bishop, Queen].include? square.piece.class) && square.piece.colour != king.piece.colour
        pieces_in_line << square
      end
    end
    return false if pieces_in_line.all? { |piece| blocked?(piece.position, king.position) }

    true
  end
  def rook_check?(king)
    squares = king.piece.valid_moves_rook(king.position).map { |square| board_square(square) }
    pieces_in_line = []
    squares.each do |square|
      if ([Rook, Queen].include? square.piece.class) && square.piece.colour != king.piece.colour
        pieces_in_line << square
      end
    end
    return false if pieces_in_line.all? { |piece| blocked?(piece.position, king.position) }

    true
  end
end
