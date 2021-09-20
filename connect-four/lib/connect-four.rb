# frozen_string_literal: true
require_relative 'resources'

class ConnectFour
  attr_reader :placed_colors

  include Resources
  def initialize
    @player1 = "Player 1"
    @player2 = "Player 2"
    @turn = @player1
    @board = NEW_BOARD
    @formatted_board = format_board
    @placed_colors = [[], [], [], [], [], [], []]
  end

  def play
    result = false
    until result
      place_color(get_input)
      update_boards
      print_board
      result = game_over?
    end
    end_message(result)
  end

  def end_message(result)
    case result
    when "tie"
      print("Tie\n")
    else
      print("#{result} wins\n")
    end
  end

  def game_over?
    winner(@board) || winner(@formatted_board) || winner(diags_to_check) || tie?
  end

  def diags_to_check
    (
    get_diags(@formatted_board) +
    get_diags(rotate_board) +
    get_diags(flip_board) +
    get_diags(rotate_board(flip_board))
    )
  end

  def tie?
    return "tie" unless @board.flatten.include?(EMPTY)
    false
  end

  def winner(array)
    out = false
    array.each do |col|
      case col
      in [*, RED, RED, RED, RED, *]
        out =  @player1
      in [*, BLUE, BLUE, BLUE, BLUE, *]
        out =  @player2
      else
      end
    end
    out
  end

  def get_diags(board)
    diagonals = []
    2.downto(0) do |row|
      diags = []
      i = 0
      current = board[row][i]
      while board[row + i]
        current = board[row + i][i]
        diags << current
        i += 1
      end
      diagonals << diags
    end
    diagonals
  end

  def rotate_board(board = @formatted_board)
    reversed = []
    board.reverse.each { |r| reversed << r.reverse}
    reversed
  end

  def flip_board(board = @formatted_board)
    board.reverse
  end
  
  def get_input
    input = nil
    until input
      print "#{@turn}, Pick a column (0-6):\n"
      input = valid_input?(gets)
    end
    input
  end

  def valid_input?(input)
    ('0'..'6').to_a.include?(input.chomp) ? input.chomp.to_i : false
  end

  def format_board
    formatted_board = [[], [], [], [], [], []]
    6.times do |row|
      @board.each do |col|
        formatted_board[row].push(col[row])
      end
    end
    formatted_board.reverse
  end

  def print_board(board = @formatted_board)
    print "---------------\n"
    board.each { |r| print "#{r.join(' ')}\n" }
    print "---------------\n"
  end

  def print_r_board
    reversed = []
    @formatted_board.reverse.each { |r| reversed << r.reverse}
  end

  def place_color(col)
    return false if @placed_colors[col].length == 6

    color_to_push = @turn == @player1 ? RED : BLUE
    @placed_colors[col].push(color_to_push)
    update_boards
    update_turn
  end

  def update_turn
    @turn = @turn == @player1 ? @player2 : @player1
  end

  def update_boards
    @placed_colors.each_with_index do |col, i|
      @board[i] = col + ([EMPTY] * (6 - col.length))
    end
    @formatted_board = format_board
  end
end
game = ConnectFour.new
game.play
