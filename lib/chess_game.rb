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
    return false unless legal_move_general?(position, moving_to)

    piece = board_square(position).piece
    if [Queen, King, Rook, Bishop].include? piece.class
      return false if blocked?(position, moving_to)

      true
    elsif piece.instance_of? Pawn
      legal_move_pawn?(position, moving_to)
    else
      piece.instance_of? Knight
    end
  end

  def legal_move_pawn?(position, moving_to)
    if position[0] == moving_to[0]
      !blocked?(position, moving_to)
    else
      board_square(moving_to).piece.colour != board_square(position).piece.colour
    end
  end

  def legal_move_general?(position, moving_to)
    starting_square = board_square(position)
    return false unless starting_square.piece.valid_moves(position).include?(moving_to)
    return false if king_checked_move?(position, moving_to, find_king(starting_square.piece.colour))
    return true unless board_square(moving_to).piece.class.superclass == Piece

    starting_square.piece.colour != board_square(moving_to).piece.colour
  end

  def blocked?(position, moving_to)
    translation = [moving_to, position].transpose.map { |x, y| x - y }
    maximum = translation.map(&:abs).max
    step = translation.map { |i| i / maximum }
    contains_piece?(intermediate_squares(maximum, position, step))
  end

  def intermediate_squares(maximum, position, step)
    1.upto(maximum - 1).map do |i|
      [position, step.map { |value| value * i }].transpose.map(&:sum)
    end
  end

  def contains_piece?(array)
    array.any? { |position| board_square(position).piece.class.superclass == Piece }
  end

  def king_checked_move?(position, moving_to, king)
    temp = board_square(moving_to).piece
    move_piece(position, moving_to)
    output = king_checked_general?(king)
    move_piece(moving_to, position)
    board_square(moving_to).piece = temp
    output
  end

  def king_checked_general?(king)
    knight_check?(king) || pawn_check?(king) || bishop_check?(king) || rook_check?(king) || adjacent_to_king?(king)
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

  def check_for_piece(king, piece_to_find, squares)
    squares.each do |square|
      return true if (square.piece.instance_of? piece_to_find) && (square.piece.colour != king.piece.colour)
    end
    false
  end

  def check_for_unblocked_piece(king, pieces_to_find, squares)
    pieces_in_line = []
    squares.each do |square|
      if (pieces_to_find.include? square.piece.class) && square.piece.colour != king.piece.colour
        pieces_in_line << square
      end
    end
    return false if pieces_in_line.all? { |piece| blocked?(piece.position, king.position) }

    true
  end

  def pawn_check?(king)
    translations = king.piece.colour == 'white' ? [[1, 1], [-1, 1]] : [[-1, -1], [1, -1]]
    squares = translations.map { |translation| board_square([translation, king.position].transpose.map(&:sum)) }
    check_for_piece(king, Pawn, squares)
  end

  def adjacent_to_king?(king)
    squares = king.piece.valid_moves_king(king.position).map { |square| board_square(square) }
    check_for_piece(king, King, squares)
  end

  def bishop_check?(king)
    squares = king.piece.valid_moves_bishop(king.position).map { |square| board_square(square) }
    check_for_unblocked_piece(king, [Bishop, Queen], squares)
  end

  def rook_check?(king)
    squares = king.piece.valid_moves_rook(king.position).map { |square| board_square(square) }
    check_for_unblocked_piece(king, [Queen, Rook], squares)
  end

  # called if king is in check at turn start will check all moves for white
  def any_legal_moves?(colour)
    all_moves_of_a_colour?(colour).each do |moves_by_piece|
      moves_by_piece.each do |move_pair|
        return true if legal_move?(move_pair[0], move_pair[1])
      end
    end
    false
  end

  def all_moves_of_a_colour?(colour)
    pieces = find_all_pieces_of_a_colour(colour)
    pieces.map do |square|
      move_to = square.piece.valid_moves(square.position)
      ([square.position] * move_to.length).zip(move_to)
    end
  end

  def find_all_pieces_of_a_colour(colour)
    board.each_with_object([]) do |column, array|
      column.each do |square|
        next if square.piece.instance_of? String

        square.piece.colour == colour ? array << square : next
      end
    end
  end
end
