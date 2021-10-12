# frozen_string_literal: true

require 'pry'
require_relative './fen'
require_relative './resources'
require_relative './pieces'

class Board
  attr_accessor :active_pieces, :board, :fen, :black_moves, :white_moves, :previous_positions
  attr_reader :white_pieces, :black_pieces, :white_king, :black_king

  include Resources

  def initialize
    @board = empty_board
    @previous_positions = []
    @fen = Fen.new(self)
    @piece_classes = {
      k: King,
      q: Queen,
      r: Rook,
      b: Bishop,
      n: Knight,
      p: Pawn
    }.freeze
    @active_pieces = create_pieces
    @fen.set_rooks
    update_board
    update_vars
  end

  def new_or_load
    puts '1: New game'
    puts '2: Load game'
    input = ' '
    input = gets.chomp until %w[1 2].include?(input)
    if input == '1'
    else
      save_to_load = @fen.get_save_name || play
      @fen.load((save_to_load))
      @active_pieces = create_pieces
      update_board
      update_vars
    end
    play
  end

  def save_game
    print("\nName your save: ")
    filename = gets.chomp.downcase.split(' ').join('_')
    available_saves = Dir.entries('./saves').select { |s| s.end_with?('.json') }.map { |s| s = s[0...-5] }

    if available_saves.include?(filename.to_s)
      print "\n#{filename}.json already exists, overwrite? (y/n): "
      overwrite = gets.chomp.downcase
      print "\nOverwrite canceled\n" unless overwrite == 'y'
      return
    end
    @fen.save(filename)
    print("\nGame saved to #{filename}.json\n")
    exit
  end

  def play
    print_board
    puts "Enter '/save' to save the position, or 'exit' to quit."
    until message = game_over_message
      puts 'Check' if @white_king.in_check? || @black_king.in_check?
      puts "#{turn} to move."
      move_to = nil
      piece_to_move = nil
      until piece_to_move && move_to
        piece_to_move = select_piece
        piece_to_move.show_moves
        move_to = get_move(piece_to_move)
      end
      piece_to_move.move(move_to)
      update_vars
    end
    puts message
  end

  def game_over_message
    message = nil
    checkmate? && message = 'Checkmate'
    stalemate? && message = 'Draw: Stalemate'
    insufficient_material? && message = 'Draw: Insufficient material'
    fifty_move_rule? && message = 'Draw: 50 move rule'
    repetition? && message = 'Draw: Three-fold repetition'
    message
  end

  def turn
    @fen.turn == 'w' ? 'White' : 'Black'
  end

  def get_move(piece)
    input = ''
    until piece.legal_moves.include?(input)
      return nil if input != ''

      puts('Select a square to move to (format: xy): ')
      input = get_input
      get_piece(input)
    end
    input
  end

  def select_piece
    input = ''
    until valid_piece?(input)
      until valid_piece?(input)
        puts 'Invalid input.' if input != ''
        puts('Select a piece to move (format: xy): ')
        input = get_input
      end
      moves = get_piece(input).legal_moves
      if (moves - get_piece(input).pin_moves(moves)).empty?
        puts 'No legal moves.'
        input = ''
      end
    end
    get_piece(input)
  end

  def get_input
    input = gets.chomp
    save_game if input.downcase == '/save'
    exit if input.downcase == 'exit'
    [input.split('')[0].to_i, input.split('')[1].to_i]
  end

  def valid_piece?(input)
    valid_inputs = @fen.turn == 'w' ? @white_pieces.map(&:position) : @black_pieces.map(&:position)
    valid_inputs.include?(input)
  end

  def get_piece(pos)
    (@active_pieces.select { |p| p.position == pos })[0]
  end

  def repetition?
    @previous_positions.count(@previous_positions[-1]) == 3
  end

  def fifty_move_rule?
    @fen.half_move >= 100
  end

  def insufficient_material?
    return true if @white_pieces.size == 1 && @black_pieces.size == 1

    insufficient = %w[KBkb KNkn KNkb KBkn].map { |s| s.split('').sort.join('') }
    pieces = @active_pieces.map(&:id).sort.join('')
    if pieces == 'BKbk'
      black_bishop_color = (@black_pieces.select { |piece| piece.id == 'b' }[0]).square_color
      white_bishop_color = (@white_pieces.select { |piece| piece.id == 'B' }[0]).square_color
      return false if black_bishop_color == white_bishop_color
    end
    insufficient.include?(@active_pieces.map(&:id).sort.join(''))
  end

  def stalemate?
    if @fen.turn == 'w'
      @white_moves.values.flatten.empty?
    else
      @black_moves.values.flatten.empty?
    end
  end

  def checkmate?
    [@white_king, @black_king].each do |k|
      return true if k.in_check? && k.legal_moves.empty? && !check_stoppable?(k.color)
    end
    false
  end

  def check_stoppable?(color)
    pieces = color == 'white' ? @white_pieces : @black_pieces
    king = color == 'white' ? @white_king : @black_king
    moves = []
    (pieces - [king]).each do |p|
      p.legal_moves.each { |m| moves << m }
    end
    moves.uniq.each do |s|
      piece_at_move_square = get_piece(s)
      @active_pieces.delete(piece_at_move_square)
      @board[s] = 'X'
      king_in_check = king.in_check?
      update_board
      return true unless king_in_check
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

  def update_vars
    @white_pieces = @active_pieces.select { |p| 'KQRBNP'.include?(p.id) }
    @black_pieces = @active_pieces.select { |p| 'kqrbnp'.include?(p.id) }
    @white_king = @white_pieces.select { |p| p.id == 'K' }[0]
    @black_king = @black_pieces.select { |p| p.id == 'k' }[0]
    @white_moves = {}
    @white_pieces.each { |p| @white_moves[p.position] = p.legal_moves }
    @black_moves = {}
    @black_pieces.each { |p| @black_moves[p.position] = p.legal_moves }
  end

  def split_to_rows(board = @board)
    out = {}
    board.each do |xy, val|
      out[xy[1]] = out[xy[1]].nil? ? {} : out[xy[1]]
      out[xy[1]].store(xy, val)
    end
    out
  end

  def print_board(board = @board)
    puts ''
    puts(split_to_rows(board).map { |row| (row[1].map { |_xy, val| val }).join(' ') })
    puts ''
  end
end
