# frozen_string_literal: true

require 'require_all'
require_all 'lib'

class Chess
  include Resources

  def initialize
    @board = EMPTY_BOARD
    @fen = Fen.new
    p @fen
  end

  def update_board
    r = 1
    @fen.placement.split('/').each do |row|
      c = 1
      row.split('').each do |s|
        if 'kqrbnp'.include?(s.downcase)
          @board[[r, c]] = PIECES[s.to_sym]
          c += 1
        else
          c += s.to_i
        end
      end
      r += 1
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
    puts split_to_rows.map { |row| (row[1].map { |_xy, val| val }).join(' ') }
    puts ''
  end
end

game = Chess.new
