# frozen_string_literal: true

require_relative './fen'
require_relative './resources'
require_relative './pieces'

class Board
  attr_accessor :active_pieces, :white_pieces, :black_pieces, :board

  include Resources

  def initialize
    @board = empty_board
    @fen = Fen.new
    @piece_classes = {
      k: King,
      q: Queen,
      r: Rook,
      b: Bishop,
      n: Knight,
      p: Pawn
    }.freeze
    @active_pieces = create_pieces
    @white_pieces = @active_pieces.select {|p| 'KQRBNP'.include?(p.id)}
    @black_pieces = @active_pieces.select {|p| 'kqrbnp'.include?(p.id)}
  end

  def start_pos; end

  def get_piece(pos)
    (@active_pieces.select {|p| p.position == pos})[0]
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

  def create_pieces
    pieces = []
    @fen.placement.split('/').each_with_index do |row, r|
      c = 1
      row.split('').each do |s|
        if 'kqrbnp'.include?(s.downcase)
          pieces << @piece_classes[s.downcase.to_sym].new(s, [c, 8 - r], self)
          c += 1
        end
        c += s.to_i
      end
    end
    pieces
  end

  def update_board
    @board = empty_board
    @active_pieces.each do |piece|
      @board[piece.position] = piece.icon
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
