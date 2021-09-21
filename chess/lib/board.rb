# frozen_string_literal: true

require_relative './fen'
require_relative './resources'

class Board
  include Resources

  def initialize
    @board = empty_board
    @fen = Fen.new
  end

  def empty_board
    out = {}
    8.downto(1) do |row|
      1.upto(8) do |col|
        b_or_w = if row.even?
                   (col.odd? ? W_SQUARE : B_SQUARE)
                 else
                   (col.even? ? W_SQUARE : B_SQUARE)
                 end
        out.store([col, row], b_or_w)
      end
    end
    out
  end

  def update_board
    @fen.placement.split('/').each_with_index do |row, r|
      c = 1
      row.split('').each do |s|
        if 'kqrbnp'.include?(s.downcase)
          @board[[c, 8 - r]] = PIECES[s.to_sym]
          c += 1
        end
        c += s.to_i
      end
    end
  end

  def split_to_rows
    out = {}
    @board.each do |xy, val|
      out[xy[1]] = out[xy[1]].nil? ? {} : out[xy[1]]
      out[xy[1]].store(xy, val)
    end
    out
  end

  def print_board
    puts ''
    puts(split_to_rows.map { |row| (row[1].map { |_xy, val| val }).join(' ') })
    puts ''
  end
end
