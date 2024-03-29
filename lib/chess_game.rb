# frozen_string_literal: true

# Methods relating to game logic moving pieces check and checkmate
module GameLogic
  def move_piece(position, moving_to, move: false)
    initial_piece = board_square(position).piece
    board_square(moving_to).piece = initial_piece
    board_square(position).piece = empty_square(position)
    initial_piece.moved = true if move
    promotion_check(moving_to, initial_piece.colour) if initial_piece.instance_of? Pawn
  end

  def promotion_check(position, colour)
    return unless [0, 7].include? position[1]

    piece = nil
    loop do
      puts 'Enter piece to promote to Q, K, B, R'
      piece = gets.chomp.downcase
      break if %w[q b k r].include? piece
    end
    promote_piece(piece, position, colour)
  end

  def promote_piece(piece, position, colour)
    case piece
    when 'q'
      board_square(position).piece = Queen.new(colour)
    when 'r'
      board_square(position).piece = Rook.new(colour)
    when 'k'
      board_square(position).piece = Knight.new(colour)
    when 'b'
      board_square(position).piece = Bishop.new(colour)
    end
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
    elsif a_piece?(board_square(moving_to))
      board_square(moving_to).piece.colour != board_square(position).piece.colour
    else
      @en_passant == moving_to
    end
  end

  def legal_move_general?(position, moving_to)
    starting_square = board_square(position)
    return false unless starting_square.piece.valid_moves(position).include?(moving_to)

    if a_piece?(board_square(moving_to)) && starting_square.piece.colour == board_square(moving_to).piece.colour
      return false
    end
    return false if king_checked_move?(position, moving_to)

    true
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
    array.any? { |position| a_piece?(board_square(position)) }
  end

  def king_checked_move?(position, moving_to)
    temp = board_square(moving_to).piece
    move_piece(position, moving_to)
    board_square(moving_to).piece.colour
    output = king_checked_general?(find_king(board_square(moving_to).piece.colour))
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
    squares = translations.map { |translation| [translation, king.position].transpose.map(&:sum) }
    squares = squares.select { |translation| translation.all? { |n| n.between?(0, 7) } }
    squares = squares.map { |square| board_square(square) }
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

  def can_castle?(king, rook, side)
    return false unless (king.piece.instance_of? King) && (rook.piece.instance_of? Rook)
    return false if blocked?(king.position, rook.position)
    return false if king_checked_general?(king)
    return false if king.piece.moved || rook.piece.moved

    not_blocked_by_check?(king, side)
  end

  def not_blocked_by_check?(king, side)
    step = side == 'king' ? [1, 0] : [-1, 0]
    intermediate_squares(3, king.position, step).each do |position|
      square = board_square(position)
      square.piece = king.piece
      output = king_checked_general?(square)
      square.piece = empty_square(square.position)
      return false if output
    end
    true
  end
end
