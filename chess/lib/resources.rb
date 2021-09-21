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
  }.freeze
  W_SQUARE = '■'
  B_SQUARE = '■'.black
end
