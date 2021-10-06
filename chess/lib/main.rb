# frozen_string_literal: true

require_relative './board'
require_relative './resources'
require 'pry'
include Resources

game = Board.new

game.create_pieces
game.update_board
game.print_board

game.get_piece([5, 2]).move([5, 4])
game.get_piece([5, 4]).move([5, 5])
game.get_piece([5, 5]).move([5, 6])
game.get_piece([4, 1]).move([8, 5])
game.get_piece([5, 6]).move([6, 7])
game.get_piece([6, 7]).move([7, 8])
