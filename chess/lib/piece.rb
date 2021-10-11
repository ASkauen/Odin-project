# frozen_string_literal: true
class Piece
  include Resources
  attr_accessor :position, :has_moved
  attr_reader :icon, :id, :color

  def initialize(id, position, board, child)
    @id = id
    @board = board
    @child = child
    @has_moved = false
    @position = position
    @icon = ICONS[id.to_sym]
  end

  def show_moves
    moves = legal_moves
    moves -= pin_moves(moves)
    moves.each do |s|
      @board.board[s] = @board.board[s].red
    end
    @board.print_board
    @board.update_board
  end

  def checking?
    if @color == 'white'
      @board.black_king.in_check?
    else
      @board.white_king.in_check?
    end
  end

  def pin_moves(moves)
    pinned = []
    king = @color == 'white' ? @board.white_king : @board.black_king
    enemy_pieces = @color == 'white' ? @board.black_pieces : @board.white_pieces
    moves.each do |move|
      temp = @position
      piece_at_move_square = @board.get_piece(move)
      @board.active_pieces.delete(@board.get_piece(move))
      @position = move
      @board.update_board
      @board.update_vars
      enemy_moves = []
      enemy_pieces.each {|p| p.legal_moves.each {|m| enemy_moves << m}}
      pinned << move if king.in_check?
      @position = temp
      @board.active_pieces << piece_at_move_square if piece_at_move_square
      @board.update_board
      @board.update_vars
    end
    pinned
  end

  def move(to)
    moves = legal_moves
    moves -= pin_moves(moves)
    if moves.include?(to)
      castle(to) if @id.downcase   == 'k' && legal_castle_moves.include?(to)
      ep_capture(to) if to == @board.fen.en_passant && @id.downcase == 'p'
      @board.active_pieces.delete(@board.get_piece(to))
      ep_square = get_ep_square(to)
      @position = to
      @has_moved = true
      promotion if @id.downcase == 'p'
      @board.update_board
      @board.print_board
      @board.fen.update_all(ep_square)
    else
      puts "Illegal move #{to}"
      false
    end
  end

  def castle(to)
    rook_row = to[0] == 3 ? 1 : 8
    rook = @board.get_piece([rook_row, to[1]])
    new_rook_pos = rook_row == 1 ? [4, to[1]] : [6, to[1]]
    rook.position = new_rook_pos
    rook.has_moved = true
  end

  def double_move(to)
    (@position[1] - to[1]).abs > 1
  end

  def ep_capture(behind)
    if @id == 'p'
      @board.active_pieces.delete(@board.get_piece([behind[0], behind[1] + 1]))
    else
      @board.active_pieces.delete(@board.get_piece([behind[0], behind[1] - 1]))
    end
    @board.update_board
  end

  def get_ep_square(to)
    if double_move(to)
      if @position[1] == 7
        return [@position[0], @position[1] - 1]
      else
        return [@position[0], @position[1] + 1]
      end
    end
    false
  end
end
