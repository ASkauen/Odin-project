require_relative './resources'

class Chess
  include Resources
  
  def initialize
    @board = EMPTY_BOARD
    @fen = STARTING_FEN
  end

  def update_board
    r = 1
    @fen[:placement].split("/").each do |row|
      c = 1
      row.split("").each do |s|
        if "kqrbnp".include?(s.downcase)
          @board[[r, c]] = PIECES[s.to_sym]
          c += 1
        else
          c += s.to_i
        end
      end
      r += 1
    end
  end

  def update_turn
    @fen[:turn] = @fen[:turn] == "w" ? "b" : "w"
  end

  def update_full_move
    @fen[:full_move] += 1
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
          section << blank if blank > 0
          section << PIECES.key(p)
          blank = 0
        end
      end
      section << blank if blank > 0
      out << section.join("")
    end
    @fen[:position] = out.join("/")
  end

  def split_to_rows
    out = {}
    @board.each do |xy, val|
      out[xy[0]] = out[xy[0]].nil? ? {} : out[xy[0]]
      out[xy[0]].store(xy, val)
    end
    out
  end

  def print_board
    puts ''
    puts split_to_rows.map { |row| (row[1].map { |xy, val| val }).join(' ') }
    puts ''
  end
end

game = Chess.new
