
require 'pry'
# Module containing methods for user to interact adn play with game
module GamePlay
  def play_game
    place_starting_pieces
    print_board
    loop do
      play_round('White')
      print_board
      break if game_end?('black')

      play_round('Black')
      print_board
      break if game_end?('white')
    end
    win_lose_draw
  end

  def play_round(colour)
    puts "#{colour} enter coordinate of piece to move e.g. A1"
    positions = get_start_finish(colour)
    start_position = positions[0]
    finish_position = positions[1]
    take_en_passant(finish_position) if board_square(start_position).piece.instance_of? Pawn
    en_passant(start_position, finish_position)
    move_piece(start_position, finish_position)
  end

  def get_start_finish(colour)
    loop do
      start_position = validate_choice_from(colour.downcase, gets.chomp.downcase)
      finish_position = validate_choice_to(gets.chomp.downcase)
      return [start_position, finish_position] if legal_move?(start_position, finish_position)

      puts 'Illegal move enter coordinate of piece to move'
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
