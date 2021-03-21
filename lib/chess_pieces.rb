
class Piece
  attr_accessor :colour, :symbol
  def initialize (colour)
    @colour = colour
    @@darkmode = true
  end
end


class King < Piece
  def initialize (colour)
    super (colour)
    @symbol = (colour == 'white') ^ @@darkmode ? "\u2654": "\u265A"
  end
end

class Queen < Piece
  def initialize (colour)
    super (colour)
    @symbol = (colour == 'white') ^ @@darkmode ? "\u2655": "\u265B"
  end
end

class Rook < Piece
  def initialize (colour)
    super (colour)
    @symbol = (colour == 'white') ^ @@darkmode ? "\u2656": "\u265C"
  end
end

class Bishop < Piece
  def initialize (colour)
    super (colour)
    @symbol = (colour == 'white') ^ @@darkmode ? "\u2657": "\u265D"
  end
end

class Knight < Piece
  def initialize (colour)
    super (colour)
    @symbol = (colour == 'white') ^ @@darkmode ? "\u2658": "\u265E"
  end
end

class Pawn < Piece
  def initialize (colour)
    super (colour)
    @symbol = (colour == 'white') ^ @@darkmode ? "\u2659": "\u265F"
  end
end

