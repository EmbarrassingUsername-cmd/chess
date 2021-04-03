
# Module containing methods for user to interact adn play with game
require 'pry'
module GamePlay
  def play_game
    place_starting_pieces
    print_board
    loop do
      play_round('White')
      break if game_end?('black')

      play_round('Black')
      break if game_end?('white')
    end
    win_lose_draw
  end

  def play_round(colour)
    puts "#{colour} enter coordinate of piece to move e.g. A1"
    input = gets.chomp.downcase
    return alterantive_input(colour.downcase, input) if %w[ooo oo save].include? input

    positions = get_start_finish(colour, input)
    start_position = positions[0]
    finish_position = positions[1]
    take_en_passant(finish_position) if board_square(start_position).piece.instance_of? Pawn
    en_passant(start_position, finish_position)
    move_piece(start_position, finish_position)
    print_board
  end

  def get_start_finish(colour, input)
    loop do
      start_position = validate_choice_from(colour.downcase, input)
      finish_position = validate_choice_to(gets.chomp.downcase)
      return [start_position, finish_position] if legal_move?(start_position, finish_position)

      puts 'Illegal move enter coordinate of piece to move'
      input = gets.chomp.downcase
    end
  end

  def en_passant(start_position, finish_position)
    if board_square(start_position).piece.instance_of? Pawn
      translation = [finish_position, start_position].transpose.map { |x, y| x - y }
      maximum = translation.map(&:abs).max
      step = translation.map { |i| i / maximum }
      @en_passant_virtual = board_square(finish_position)
      return @en_passant = intermediate_squares(maximum, start_position, step).flatten
    end

    @en_passant = nil
  end

  def take_en_passant(finish_position)
    @en_passant_virtual.piece = empty_square(finish_position + [0, 1]) if @en_passant == finish_position
  end

  def validate_choice_from(colour, input)
    converted_input = convert_input(input)
    loop do
      if converted_input.include?(nil)
        puts 'Enter valid square'
        converted_input = convert_input(gets.chomp.downcase)
        next
      end
      square = board_square(converted_input)
      break if a_piece?(square) && square.piece.colour == colour

      puts 'Enter valid piece'
      converted_input = convert_input(gets.chomp.downcase)
    end
    converted_input
  end

  def validate_choice_to(input)
    converted_input = convert_input(input)
    loop do
      if converted_input.include?(nil)
        puts 'Enter valid square'
        converted_input = convert_input(gets.chomp.downcase)
        next
      end
      return converted_input
    end
  end

  def convert_input(input)
    return [nil, nil] unless input.length == 2

    x = [*'a'..'h'].freeze.index(input[0])
    y = [*'1'..'8'].freeze.index(input[1])
    [x, y]
  end

  def alterantive_input(colour, input)
    save if input == 'save'
    king = colour == 'white' ? board_square([4, 0]) : board_square([4, 7])
    if input == 'oo'
      rook = colour == 'white' ? board_square([7, 0]) : board_square([7, 7])
      side = 'king'
    elsif input == 'ooo'
      rook = colour == 'white' ? board_square([0, 0]) : board_square([0, 7])
      side = 'queen'
    end
    castle(colour, king, rook, side)
    print_board
  end

  def castle(colour, king, rook, side)
    return play_round(colour) unless can_castle?(king, rook, side)

    if side == 'queen'
      king_transpose = [-2, 0]
      rook_transpose = [3, 0]
    else
      king_transpose = [2, 0]
      rook_transpose = [-2, 0]
    end
    king_position = [king.position, king_transpose].transpose.map(&:sum)
    rook_position = [rook.position, rook_transpose].transpose.map(&:sum)
    castle_move(king, king_position, rook, rook_position)
  end

  def castle_move(king, king_position, rook, rook_position)
    move_piece(king.position, king_position)
    move_piece(rook.position, rook_position)
  end

  def game_end?(colour)
    return false if any_legal_moves?(colour)

    king = find_king(colour)
    @loser = king_checked_general?(king) ? colour : 'draw'
  end

  def win_lose_draw
    if @loser == 'draw'
      puts "Stalemate it's a draw"
    else
      puts @loser == 'white' ? 'Checkmate Black_wins' : 'Checkmate White_wins'
    end
  end
end
