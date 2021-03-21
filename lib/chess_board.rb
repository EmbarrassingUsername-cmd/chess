require_relative 'chess_pieces.rb'

class Board
  attr_reader :board

  HORIZONTAL_LINES = [
    [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]],
    [[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]],
    [[0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2]],
    [[0, 3], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3]],
    [[0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4]],
    [[0, 5], [1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [6, 5], [7, 5]],
    [[0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6]],
    [[0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7]]
  ].freeze
  EMPTY_BOARD =  [
    ["\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0"],
    ["\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1"],
    ["\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0"],
    ["\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1"],
    ["\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0"],
    ["\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1"],
    ["\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0"],
    ["\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1", "\u25A0", "\u25A1"]
  ].freeze

  def initialize
    @board = [*0..7].product([*0..7]).each_slice(8).to_a.map do |sub_array|
      sub_array.map {|position| BoardSquare.new(position) }
    end
  end

  def board_square(position)
    board[position[0]][position[1]]
  end

  def empty_square(position)
    EMPTY_BOARD[position[0]][position[1]]
  end

  def place_starting_pieces
    place_pawns
    place_rooks
    place_bishops
    place_knights
    place_kings
    place_queens
    fill_empty
  end

  def place_pawns
    HORIZONTAL_LINES[1].each { |position| board_square(position).piece = Pawn.new('white') }
    HORIZONTAL_LINES[6].each { |position| board_square(position).piece = Pawn.new('black') }
  end

  def place_rooks
    [[0,0], [7,0]].each { |position| board_square(position).piece = Rook.new('white') }
    [[0,7], [7,7]].each { |position| board_square(position).piece = Rook.new('black') }
  end

  def place_bishops
    [[2,0], [5,0]].each { |position| board_square(position).piece = Bishop.new('white') }
    [[2,7], [5,7]].each { |position| board_square(position).piece = Bishop.new('black') }
  end

  def  place_knights
    [[1,0], [6,0]].each { |position| board_square(position).piece = Knight.new('white') }
    [[1,7], [6,7]].each { |position| board_square(position).piece = Knight.new('black') }
  end

  def place_kings
    board_square([4,0]).piece = King.new('white')
    board_square([4,7]).piece = King.new('black')
  end

  def place_queens
    board_square([3,0]).piece = Queen.new('white')
    board_square([3,7]).piece = Queen.new('black')
  end

  def fill_empty
    HORIZONTAL_LINES[2, 4].each do |line|
      line.each { |position| board_square(position).piece = empty_square(position) }
    end
  end

  def print_board
    HORIZONTAL_LINES.reverse.each_with_index do |line, index|
      print "#{8 - index}"
      line.each do |position|
        if board_square(position).piece.class.superclass == Piece
          print "  #{board_square(position).piece.symbol}"
        else
          print "  #{board_square(position).piece}"
        end
      end
      print "\n\n"
    end
    print "   #{[*'A'..'H'].join('  ')}"
  end
end

class BoardSquare
  attr_accessor :position, :piece

  def initialize(position)
    @position = position
    @piece = 'E'
  end

end
