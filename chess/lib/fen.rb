# frozen_string_literal: true

class Fen
  attr_accessor :placement, :turn, :castling, :en_passant, :half_move, :full_move

  def initialize
    @placement = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'
    @turn = 'w'
    @castling = 'KQkq'
    @en_passant = '-'
    @half_move =  0
    @full_move =  1
  end

  def update_turn
    @turn = @turn == 'w' ? 'b' : 'w'
  end

  def update_full_move
    @full_move += 1
  end

  def update_position
    out = []
    split_to_rows.each_value do |row|
      blank = 0
      section = []
      row.each_value do |p|
        if [W_SQUARE, B_SQUARE].include?(p)
          blank += 1
        else
          section << blank if blank.positive?
          section << PIECES.key(p)
          blank = 0
        end
      end
      section << blank if blank.positive?
      out << section.join('')
    end
    @position = out.join('/')
  end
end
