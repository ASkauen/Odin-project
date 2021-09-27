# frozen_string_literal: true

require_relative './resources'
require_relative './board'

class Piece
  include Resources
  attr_accessor :position
  attr_reader :icon, :id

  def initialize(id, position, board, offsets)
    @id = id
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
        legal << s_check if [W_SQUARE, B_SQUARE].include?(@board.board[s_check])
      end
    else
      @offsets.each do |offset|
        s_check = [(@position[0] + offset[0]), (@position[1] + offset[1])]
        while [W_SQUARE, B_SQUARE].include?(@board.board[s_check])
          legal << s_check
          s_check = [(s_check[0] + offset[0]), (s_check[1] + offset[1])]
        end
      end
    end
    legal
  end

  def show_moves
    legal_moves.each do |s|
      @board.board[s] = W_SQUARE.red
    end
    @board.print_board
    @board.board = @board.empty_board
    @board.update_board
  end

  def move(to); end
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
