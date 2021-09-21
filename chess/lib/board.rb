# frozen_string_literal: true

require_relative './fen'
require_relative './resources'

class Board
  include Resources

  def initialize
    @board = new_board
    @fen = Fen.new
  end

  def new_board
    out = {}
    8.times do |row|
      8.times do |col|
        b_or_w = if row.odd?
                   col.odd? ? '■'.black : '■'
                 else
                   col.even? ? '■'.black : '■'
                 end
        out.store([row + 1, col + 1], b_or_w)
      end
    end
    out
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
