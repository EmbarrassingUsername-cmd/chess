# frozen_string_literal: true

# Defines possible moves for each piece
module Moves
  def valid_moves_rook(position)
    moves = (([[0] * 15, [*-7..7]].transpose + [[*-7..7], [0] * 15].transpose)).map do |translation|
      [position, translation].transpose.map(&:sum)
    end
    moves.delete(position)
    moves.select { |result| result.all? { |coord| coord.between?(0, 7) } }
  end

  def valid_moves_bishop(position)
    moves = (([[*-7..7], [*-7..7]].transpose + [[*-7..7], [*-7..7].reverse].transpose)).map do |translation|
      [position, translation].transpose.map(&:sum)
    end
    moves.delete(position)
    moves.select { |result| result.all? { |coord| coord.between?(0, 7) } }
  end

  def valid_moves_knight(position)
    moves = ([-2, 2].product([-1, 1]) + [-1, 1].product([-2, 2])).map do |translation|
      [position, translation].transpose.map(&:sum)
    end
    moves.select { |result| result.all? { |coord| coord.between?(0, 7) } }
  end

  def valid_moves_pawn(position)
    translation_pawn
    moves = translation_pawn.map do |translation|
      [position, translation].transpose.map(&:sum)
    end
    moves.select { |result| result.all? { |coord| coord.between?(0, 7) } }
  end

  def valid_moves_king(position)
    moves = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].map do |translation|
      [position, translation].transpose.map(&:sum)
    end
    moves.select { |result| result.all? { |coord| coord.between?(0, 7) } }
  end

  def translation_pawn
    if colour == 'white'
      @moved ? [[0, 1], [1, 1], [-1, 1]] : [[0, 1], [0, 2], [1, 1], [-1, 1]]
    else
      @moved ? [[0, -1], [1, -1], [-1, -1]] : [[0, -1], [0, -2], [1, -1], [-1, -1]]
    end
  end
end
