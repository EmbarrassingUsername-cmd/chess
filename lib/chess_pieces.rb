# frozen_string_literal: true

require_relative 'chess_moves'

class Piece
  include Moves
  attr_accessor :colour, :symbol

  def initialize(colour)
    @colour = colour
    @darkmode = true
  end
end

class King < Piece
  def initialize(colour)
    super colour
    @symbol = (colour == 'white') ^ @darkmode ? "\u2654" : "\u265A"
  end

  def valid_moves(position)
    valid_moves_king(position)
  end
end

class Queen < Piece
  def initialize(colour)
    super colour
    @symbol = (colour == 'white') ^ @darkmode ? "\u2655" : "\u265B"
  end

  def valid_moves(position)
    valid_moves_rook(position) + valid_moves_bishop(position)
  end
end

class Rook < Piece
  def initialize(colour)
    super colour
    @symbol = (colour == 'white') ^ @darkmode ? "\u2656" : "\u265C"
  end

  def valid_moves(position)
    valid_moves_rook(position)
  end
end

class Bishop < Piece
  def initialize(colour)
    super colour
    @symbol = (colour == 'white') ^ @darkmode ? "\u2657" : "\u265D"
  end

  def valid_moves(position)
    valid_moves_bishop(position)
  end
end

class Knight < Piece
  def initialize(colour)
    super colour
    @symbol = (colour == 'white') ^ @darkmode ? "\u2658" : "\u265E"
  end

  def valid_moves(position)
    valid_moves_knight(position)
  end
end

class Pawn < Piece
  attr_accessor :moved

  def initialize(colour)
    super colour
    @symbol = (colour == 'white') ^ @darkmode ? "\u2659" : "\u265F"
    @moved = false
  end

  def valid_moves(position)
    valid_moves_pawn(position)
  end
end
