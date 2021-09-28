# frozen_string_literal: true

require_relative './resources'
require_relative './board'

class Piece
  include Resources
  attr_accessor :position
  attr_reader :icon, :id

  def initialize(id, position, board, offsets)
    @id = id
    @color = 'kqrbnp'.include?(@id) ? 'black' : 'white'
    @position = position
    @board = board
    @offsets = offsets
    @icon = ICONS[id.to_sym]
    @offsets[0][1] = -1 if @id == 'p'
  end

  def legal_moves
    legal = []
    if 'pkn'.include?(@id.downcase)
      @offsets.each do |offset|
        s_check = [(@position[0] + offset[0]), (@position[1] + offset[1])]
        legal << s_check if empty_square?(s_check) || enemy_piece?(s_check)
      end
    else
      @offsets.each do |offset|
        s_check = [(@position[0] + offset[0]), (@position[1] + offset[1])]
        while empty_square?(s_check)
          legal << s_check
          s_check = [(s_check[0] + offset[0]), (s_check[1] + offset[1])]
        end
        legal << s_check if enemy_piece?(s_check)
      end
    end
    legal
  end

  def empty_square?(pos)
    [W_SQUARE, B_SQUARE].include?(@board.board[pos])
  end

  def enemy_piece?(pos)
    if @color == 'white'
      @board.black_pieces.any? {|p| p.position == pos}
    else
      @board.white_pieces.any? {|p| p.position == pos}
    end
  end

  def show_moves
    legal_moves.each do |s|
      @board.board[s] = @board.board[s].red
    end
    @board.print_board
    @board.update_board
  end

  def move(to)
    if legal_moves.include?(to)
      @position = to
      @board.update_board
    else
      puts "Illegal move"
      false
    end
  end
end

class King < Piece
  def initialize(id, position, board)
    super(
      id,
      position,
      board,
      [
        [+1, 0],
        [+1, -1],
        [+1, +1],
        [0, +1],
        [0, -1],
        [-1, 0],
        [-1, -1],
        [-1, +1]
      ]
    )

    def in_check?
      enemey_pieces.each do |piece|

      end
    end
  end
end

class Queen < Piece
  def initialize(id, position, board)
    super(
      id,
      position,
      board,
      [
        [+1, 0],
        [+1, -1],
        [+1, +1],
        [0, +1],
        [0, -1],
        [-1, 0],
        [-1, -1],
        [-1, +1]
      ]
    )
  end
end

class Rook < Piece
  def initialize(id, position, board)
    super(
      id,
      position,
      board,
      [
        [+1, 0],
        [0, +1],
        [0, -1],
        [-1, 0]
      ]
    )
  end
end

class Bishop < Piece
  def initialize(id, position, board)
    super(
      id,
      position,
      board,
      [
        [+1, -1],
        [+1, +1],
        [-1, -1],
        [-1, +1]
      ]
    )
  end
end

class Knight < Piece
  def initialize(id, position, board)
    super(
      id,
      position,
      board,
      [
        [+2, -1],
        [+2, +1],
        [-2, -1],
        [-2, +1],
        [+1, -2],
        [+1, +2],
        [-1, -2],
        [-1, +2]
      ]
    )
  end
end

class Pawn < Piece
  def initialize(id, position, board)
    super(
      id,
      position,
      board,
      [
        [0, +1]
      ]
    )
  end
end
