# frozen_string_literal: true

require_relative './resources'
require_relative './board'

class Piece
  include Resources
  attr_accessor :position
  attr_reader :icon

  def initialize(id, position, board)
    @id = id
    @position = position
    @board = board
    @icon = ICONS[id.to_sym]
  end

  def move(to); end
end

class King < Piece
  def initialize(id, position, board)
    super(id, position, board)
    @move_offsets = [
      [+1, 0],
      [+1, -1],
      [+1, +1],
      [0, +1],
      [0, -1],
      [-1, 0],
      [-1, -1],
      [-1, +1]
    ]
  end
end

class Queen < Piece
  def initialize(id, position, board)
    super(id, position, board)
    @move_offsets = [
      [+1, 0],
      [+1, -1],
      [+1, +1],
      [0, +1],
      [0, -1],
      [-1, 0],
      [-1, -1],
      [-1, +1]
    ]
  end
end

class Rook < Piece
  def initialize(id, position, board)
    super(id, position, board)
    @move_offsets = [
      [+1, 0],
      [0, +1],
      [0, -1],
      [-1, 0]
    ]
  end
end

class Bishop < Piece
  def initialize(id, position, board)
    super(id, position, board)
    @move_offsets = [
      [+1, -1],
      [+1, +1],
      [-1, -1],
      [-1, +1]
    ]
  end
end

class Knight < Piece
  def initialize(id, position, board)
    super(id, position, board)
    @move_offsets = [
      [+2, -1],
      [+2, +1],
      [-2, -1],
      [-2, +1],
      [+1, -2],
      [+1, +2],
      [-1, -2],
      [-1, +2]
    ]
  end
end

class Pawn < Piece
  def initialize(id, position, board)
    super(id, position, board)
    @move_offsets = [
      [0, +1]
    ]
  end
end
