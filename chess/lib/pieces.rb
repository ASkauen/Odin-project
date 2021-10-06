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
      board,
      self
    )
  end

  def king_pos
    if @color == 'white'
      @board.white_king.position
    else
      @board.black_king.position
    end
  end

  def legal_moves(pos = @position)
    legal = []
    @offsets.each do |offset|
      s_check = [(pos[0] + offset[0]), (pos[1] + offset[1])]
      legal << s_check if @board.empty_square?(s_check) || @board.enemy_piece?(@color, s_check)
    end

    legal
  end

  def remove_check_moves
    legal_moves.reject do |move|
      in_check?(move)
    end
  end

  def in_check?(pos = @position, moves = nil)
    enemy_pieces = @color == 'white' ? @board.black_pieces : @board.white_pieces
    if moves
      return true if moves.include?(pos)
    else
      enemy_pieces.each do |piece|
        return true if piece.legal_moves.include?(pos)
      end
    end
    false
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
      board,
      self
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
      board,
      self
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
  def initialize(id, position, board)
    @position = position
    @color = 'kqrbnp'.include?(id) ? 'black' : 'white'
    @offsets = [
      [+1, -1],
      [+1, +1],
      [-1, -1],
      [-1, +1]
    ]
    super(
      id,
      position,
      board,
      self
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
      board,
      self
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
      board,
      self
    )
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
    legal << two_move unless @has_moved
    legal
  end

  def promotion
    user_input = " "
    if @color == 'white'
      if @position[1] == 8
        until 'qrkb'.include?(user_input)
          puts "Promote to (Q)ueen, (R)ook, (K)night or (B)ishop?:"
          user_input = gets.chomp.downcase
        end
      end
    else
      if @position[1] == 1
        until 'qrkb'.include?(user_input)
          puts "Promote to (Q)ueen, (R)ook, (K)night or (B)ishop?:"
          user_input = gets.chomp.downcase
        end
      end
    end
    promote_piece(user_input) if user_input != " "
  end

  def promote_piece(input)
    pos = @position
    id = @color == 'white' ? input.upcase : input
    case input
    when "q"
      piece = Queen.new(id, pos, @board)
    when "r"
      piece = Rook.new(id, pos, @board)
    when "k"
      id = @color == 'white' ? 'N' : 'n'
      piece = Knight.new(id, pos, @board)
    when "b"
      piece = Bishop.new(id, pos, @board)
    end
    @board.active_pieces.delete(@board.get_piece(pos))
    @board.active_pieces << piece
  end
end
