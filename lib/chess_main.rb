# frozen_string_literal: true

require_relative 'chess_pieces'
require_relative 'chess_board'
require_relative 'chess_game'
require_relative 'chess_save_load'
require 'pry'

def new_game
  board = Board.new
  board.play_game
end

def load_game
  LoadGame.new.load
end

def choose_game
  puts 'Enter new or load to start a new game or load an existing game'
  input = ''
  loop do
    input = gets.chomp.downcase
    break if %w[load new].include?(input)

    puts 'Invalid entry must enter new or load'
  end
  new_game if input == 'new'
  load_game if input == 'load'
end

choose_game
