# frozen_string_literal: true

require_relative 'chess_pieces'
require_relative 'chess_board'
require_relative 'chess_game'
require_relative 'chess_save_load'
require 'pry'

def choose_game
  a = LoadGame.new
  a.load
end

choose_game
