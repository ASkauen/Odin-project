# frozen_string_literal: true

require_relative './fen'
require_relative './resources'
require_relative './pieces'

class Board
  attr_accessor :active_pieces, :board
  attr_reader :white_pieces, :black_pieces, :white_king, :black_king

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
    @white_pieces = @active_pieces.select { |p| 'KQRBNP'.include?(p.id) }
    @black_pieces = @active_pieces.select { |p| 'kqrbnp'.include?(p.id) }
    @white_king = @white_pieces.select { |p| p.id == 'K' }[0]
    @black_king = @black_pieces.select { |p| p.id == 'k' }[0]
  end

  def start_pos; end

  def get_piece(pos)
    (@active_pieces.select { |p| p.position == pos })[0]
  end

  def checkmate?
    [@white_king, @black_king].each do |k|
      return true if k.in_check? && k.remove_check_moves.empty? && !check_blockable?(k.color)
    end
    false
  end

  def check_blockable?(color)
    pieces = color == 'white' ? @white_pieces : @black_pieces
    king = color == 'white' ? @white_king : @black_king
    moves = []
    (pieces - [king]).each do |p|
      p.legal_moves.each { |m| moves << m }
    end
    moves.uniq.each do |s|
      @board[s] = 'B'
      return true unless king.in_check?

      update_board
    end
    false
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

  def empty_square?(pos)
    [W_SQUARE, B_SQUARE].include?(@board[pos])
  end

  def enemy_piece?(color, pos)
    if color == 'white'
      @black_pieces.any? { |p| p.position == pos }
    else
      @white_pieces.any? { |p| p.position == pos }
    end
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
