# frozen_string_literal: true

require_relative './piece'

class King < Piece
  def initialize(id, position, board)
    @position = position
    @color = 'kqrbnp'.include?(id) ? 'black' : 'white'
    @offsets = [
      [+1, 0],
      [+1, -1],
      [+1, +1],
      [0, +1],
      [0, -1],
      [-1, 0],
      [-1, -1],
      [-1, +1]
    ]
    super(
      id,
      position,
      board
    )
  end

  def legal_moves(once = false, pos = @position)
    legal = []
    @offsets.each do |offset|
      s_check = [(pos[0] + offset[0]), (pos[1] + offset[1])]
      legal << s_check if @board.empty_square?(s_check) || @board.enemy_piece?(@color, s_check)
    end
    return legal if once
    legal += legal_castle_moves unless in_check?
    legal - check_moves(legal)
  end

  def check_moves(moves)
    illegal = []
    moves.each do |move|
      temp = @position
      @position = move
      @board.update_board
      illegal << move if in_check?
      @position = temp
      @board.update_board
    end
    illegal
  end

  def in_check?(pos = @position)
    enemy_pieces = @color == 'white' ? @board.black_pieces : @board.white_pieces
    enemy_king = enemy_pieces.select { |p| p.id.downcase == 'k' }[0]
    return true if enemy_king.legal_moves(true).include?(pos)

    enemy_pieces = enemy_pieces.reject { |p| p.id.downcase == 'k' }
    enemy_pieces.each do |piece|
      return true if piece.legal_moves.include?(pos)
    end
    false
  end

  def legal_castle_moves
    legal = []
    fen_kingside = @color == 'white' ? 'K' : 'k'
    fen_queenside = @color == 'black' ? 'Q' : 'q'
    rank = @color == 'white' ? 1 : 8
    legal << [7, rank] if kingside_clear?(rank) && @board.fen.castling.include?(fen_kingside)
    legal << [3, rank] if queenside_clear?(rank) && @board.fen.castling.include?(fen_queenside)
    legal
  end

  def kingside_clear?(rank)
    [[6, rank], [7, rank]].each do |square|
      return false if @board.get_piece(square) || in_check?(square)
    end
    true
  end

  def queenside_clear?(rank)
    [[2, rank], [3, rank], [4, rank]].each do |square|
      return false if @board.get_piece(square) || in_check?(square)
    end
    true
  end
end

class Queen < Piece
  def initialize(id, position, board)
    @position = position
    @color = 'kqrbnp'.include?(id) ? 'black' : 'white'
    @offsets = [
      [+1, 0],
      [+1, -1],
      [+1, +1],
      [0, +1],
      [0, -1],
      [-1, 0],
      [-1, -1],
      [-1, +1]
    ]
    super(
      id,
      position,
      board
    )
  end

  def legal_moves(pos = @position)
    legal = []
    @offsets.each do |offset|
      s_check = [(pos[0] + offset[0]), (pos[1] + offset[1])]
      while @board.empty_square?(s_check)
        legal << s_check
        s_check = [(s_check[0] + offset[0]), (s_check[1] + offset[1])]
      end
      legal << s_check if @board.enemy_piece?(@color, s_check)
    end

    legal
  end
end

class Rook < Piece
  def initialize(id, position, board)
    @position = position
    @color = 'kqrbnp'.include?(id) ? 'black' : 'white'
    @offsets = [
      [+1, 0],
      [0, +1],
      [0, -1],
      [-1, 0]
    ]
    super(
      id,
      position,
      board
    )
  end

  def legal_moves(pos = @position)
    legal = []
    @offsets.each do |offset|
      s_check = [(pos[0] + offset[0]), (pos[1] + offset[1])]
      while @board.empty_square?(s_check)
        legal << s_check
        s_check = [(s_check[0] + offset[0]), (s_check[1] + offset[1])]
      end
      legal << s_check if @board.enemy_piece?(@color, s_check)
    end

    legal
  end
end

class Bishop < Piece
  attr_reader :square_color

  def initialize(id, position, board)
    @position = position
    @color = 'kqrbnp'.include?(id) ? 'black' : 'white'
    @square_color = if position[1].odd?
                      position[0].odd? ? 'black' : 'white'
                    else
                      (position[0].even? ? 'black' : 'white')
                    end
    @offsets = [
      [+1, -1],
      [+1, +1],
      [-1, -1],
      [-1, +1]
    ]
    super(
      id,
      position,
      board
    )
  end

  def legal_moves(pos = @position)
    legal = []
    @offsets.each do |offset|
      s_check = [(pos[0] + offset[0]), (pos[1] + offset[1])]
      while @board.empty_square?(s_check)
        legal << s_check
        s_check = [(s_check[0] + offset[0]), (s_check[1] + offset[1])]
      end
      legal << s_check if @board.enemy_piece?(@color, s_check)
    end

    legal
  end
end

class Knight < Piece
  def initialize(id, position, board)
    @position = position
    @color = 'kqrbnp'.include?(id) ? 'black' : 'white'
    @offsets = [
      [+2, -1],
      [+2, +1],
      [-2, -1],
      [-2, +1],
      [+1, -2],
      [+1, +2],
      [-1, -2],
      [-1, +2]
    ]
    super(
      id,
      position,
      board
    )
  end

  def legal_moves(pos = @position)
    legal = []
    @offsets.each do |offset|
      s_check = [(pos[0] + offset[0]), (pos[1] + offset[1])]
      legal << s_check if @board.empty_square?(s_check) || @board.enemy_piece?(@color, s_check)
    end
    legal
  end
end

class Pawn < Piece
  def initialize(id, position, board)
    @position = position
    @color = 'kqrbnp'.include?(id) ? 'black' : 'white'
    @offsets = [
      [0, +1]
    ]
    super(
      id,
      position,
      board
    )
    base = @color == 'white' ? 0 : 5
    @has_moved = true if @position[1] != base + 2
  end

  def legal_moves(pos = @position)
    p_or_m = color == 'white' ? :+ : :-
    enemy_pieces = color == 'white' ? @board.black_pieces.map(&:icon) : @board.white_pieces.map(&:icon)
    left_diag = [pos[0] - 1, pos[1].public_send(p_or_m, 1)]
    right_diag = [pos[0] + 1, pos[1].public_send(p_or_m, 1)]
    two_move = [pos[0], pos[1].public_send(p_or_m, 2)]
    legal = []
    @offsets.each do |offset|
      s_check = [(pos[0] + offset[0]), pos[1].public_send(p_or_m, 1)]
      legal << s_check if @board.empty_square?(s_check)
    end
    legal << left_diag if enemy_pieces.include?(@board.board[left_diag]) || left_diag == @board.fen.en_passant
    legal << right_diag if enemy_pieces.include?(@board.board[right_diag]) || right_diag == @board.fen.en_passant
    legal << two_move unless @has_moved || @board.get_piece(two_move)
    legal
  end

  def promotion
    out = ' '
    if @color == 'white'
      out = promotion_input if @position[1] == 8
    elsif @position[1] == 1
      out = promotion_input
    end
    promote_piece(out) if out != ' '
  end

  def promotion_input
    user_input = ' '
    until 'qrkb'.include?(user_input)
      puts 'Promote to (Q)ueen, (R)ook, (K)night or (B)ishop?:'
      user_input = gets.chomp.downcase
    end
    user_input
  end

  def promote_piece(input)
    pos = @position
    id = @color == 'white' ? input.upcase : input
    case input
    when 'q'
      piece = Queen.new(id, pos, @board)
    when 'r'
      piece = Rook.new(id, pos, @board)
    when 'k'
      id = @color == 'white' ? 'N' : 'n'
      piece = Knight.new(id, pos, @board)
    when 'b'
      piece = Bishop.new(id, pos, @board)
    end
    @board.active_pieces.delete(@board.get_piece(pos))
    @board.active_pieces << piece
  end
end
