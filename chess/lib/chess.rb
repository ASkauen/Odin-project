# frozen_string_literal: true

require 'require_all'
require_all 'lib'

class Chess
  include Resources

  def initialize
    @board = EMPTY_BOARD
    @fen = Fen.new
  end

  def update_board
    @fen.placement.split('/').each_with_index do |row, r|
      c = 1
      row.split('').each do |s|
        if 'kqrbnp'.include?(s.downcase)
          @board[[r + 1, c]] = PIECES[s.to_sym]
          c += 1
        end
        c += s.to_i
      end
    end
  end

  def split_to_rows
    out = {}
    @board.each do |xy, val|
      out[xy[0]] = out[xy[0]].nil? ? {} : out[xy[0]]
      out[xy[0]].store(xy, val)
    end
    out
  end

  def print_board
    puts ''
    puts(split_to_rows.map { |row| (row[1].map { |_xy, val| val }).join(' ') })
    puts ''
  end
end

game = Chess.new

game.update_board
game.print_board