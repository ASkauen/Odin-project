require_relative './resources'

class Chess
  include Resources
  
  def initialize
    @board = EMPTY_BOARD
    @fen = STARTING_FEN
    print_board
    parse_fen
    print_board
  end

  def parse_fen
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

  def print_board
    out = {}
    puts ''
    @board.each do |xy, val|
      out[xy[0]] = out[xy[0]].nil? ? {} : out[xy[0]]
      out[xy[0]].store(xy, val)
    end
    puts out.map { |row| (row[1].map { |xy, val| val }).join(' ') }
    puts ''
  end
end

game = Chess.new