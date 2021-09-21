# frozen_string_literal: true

require 'colorize'

module Resources
  PIECES = {
    K: '♚',
    Q: '♛',
    R: '♜',
    B: '♝',
    N: '♞',
    P: '♟',
    k: '♚'.black,
    q: '♛'.black,
    r: '♜'.black,
    b: '♝'.black,
    n: '♞'.black,
    p: '♟'.black
  }
  W_SQUARE = '■'
  B_SQUARE = '■'.black
  EMPTY_BOARD = {}
  8.times do |row|
    8.times do |col|
      b_or_w = if row.odd?
                 col.odd? ? '■'.black : '■'
               else
                 col.even? ? '■'.black : '■'
               end
      EMPTY_BOARD.store([row + 1, col + 1], b_or_w)
    end
  end
  EMPTY_BOARD.to_a.reverse.to_h
end
