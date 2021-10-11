# frozen_string_literal: true

require_relative './board'
require_relative './resources'
require 'pry'
include Resources

game = Board.new

# game.fen.placement = "rnbqkbnr/ppp1pppp/8/8/8/8/PPP1PPPP/R3KBNR"
game.active_pieces = game.create_pieces
game.update_board
game.update_vars
game.print_board

game.play