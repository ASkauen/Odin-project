# frozen_string_literal: true
class Piece
  include Resources
  attr_accessor :position
  attr_reader :icon, :id, :color, :has_moved

  def initialize(id, position, board, child)
    @id = id
    @board = board
    @child = child
    @has_moved = false
    @position = position
    @icon = ICONS[id.to_sym]
  end

  def show_moves
    legal_moves.each do |s|
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
      @position = move
      @board.update_board
      enemy_moves = []
      enemy_pieces.each {|p| p.legal_moves.each {|m| enemy_moves << m}}
      pinned << move if enemy_moves.include?(king.position)
      @position = temp
      @board.update_board
    end
    pinned
  end

  def move(to)
    moves = legal_moves
    moves -= pin_moves(moves)
    if moves.include?(to)
      ep_capture(to) if to == @board.fen.en_passant && @id.downcase == 'p'
      @board.active_pieces.delete(@board.get_piece(to))
      @position = to
      @has_moved = true
      promotion if @id.downcase == 'p'
      @board.update_board
      @board.print_board
      @board.fen.update_all(get_ep_square(to))
      puts 'Check' if checking?
    else
      puts "Illegal move #{to}"
      false
    end
  end

  def double_move(to)
    return true if @id.downcase == 'p' && ((@position[1] - to[1]).abs > 1)

    false
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
