# frozen_string_literal: true

require_relative './board'
require_relative './resources'
require 'pry'
include Resources

game = Board.new

game.create_pieces
game.update_board
game.print_board

game.get_piece([5, 7]).move([5, 5])
game.get_piece([5, 5]).move([5, 4])
game.get_piece([5, 4]).move([5, 3])
game.get_piece([5, 3]).move([4, 2])
game.get_piece([4, 2]).move([3, 1])
