# frozen_string_literal: true

# Module to save game
module Save
  def save(colour)
    @turn = colour
    save = YAML.dump(self)
    Dir.mkdir('saves') unless Dir.exist?('saves')
    puts 'Enter name for save'
    name = gets.chomp.downcase
    File.open("saves/#{name}.yaml", 'w') { |file| file.puts save }
    puts "Saved as #{name}. Please open to play again"
    exit
  end
end

# Class for loading game
class LoadGame
  def load
    permitted = [Board, Piece, BoardSquare, Rook, Bishop, Queen, King, Knight, Pawn].freeze
    begin
      loaded_game = File.read("saves/#{gets.chomp.downcase}.yaml")
      game = YAML.safe_load(loaded_game, permitted_classes: permitted, aliases: true)
    rescue Errno::ENOENT
      puts 'File not found starting new game'
      game = nil
    end
    start_loaded_game(game)
  end

  def start_loaded_game(game)
    if game.nil?
      game = Board.new
      game.play_game
    elsif game.turn == 'black'
      game.print_board
      game.play_round('black')
      game.win_lose_draw if game.game_end?('white')
    else
      game.print_board
      game.loop_rounds
      game.win_lose_draw
    end
  end
end
