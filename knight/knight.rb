# frozen_string_literal: true

require 'colorize'
require 'pry'

class Board
  attr_accessor :board, :knight_pos, :root

  def initialize
    @board = {}
    @knight_pos = [2, 4]
    @paths = []
    create_board
  end

  def create_tree(from, to)
    root = Node.new(from)
    queue = [root]
    current = queue.shift
    until current.data == to
      available_moves(current.data).each do |move|
        current.children << node = Node.new(move, current)
        queue << node
      end
      current = queue.shift
    end
    current
  end

  def knight_moves(from, to)
    @knight_pos = from
    current = create_tree(from, to)
    history = []
    make_history(current, history, from)
    print_knight_moves(history, from, to)
  end

  def make_history(current, history, from)
    until current.data == from
      history << current.data
      current = current.parent
    end
    history << current.data
  end

  def print_knight_moves(history, from, to)
    show_knight
    sleep 1
    history.reverse[1..-1].each { |move| move_knight(move); sleep 1}
    puts "You made it in #{history.size - 1} moves"
    puts "To get from #{from} to #{to} you must traverse the following path:"
    history.reverse.each { |move| puts move.to_s }
  end

  def create_board
    8.times do |x|
      8.times do |y|
        b_or_w = if x.odd?
                   y.even? ? '■'.black : '■'
                 else
                   y.odd? ? '■'.black : '■'
                 end
        @board.store([x + 1, y + 1], b_or_w)
      end
    end
  end



  def print_board
    out = {}
    puts ''
    @board.each do |xy, val|
      out[xy[0]] = out[xy[0]].nil? ? {} : out[xy[0]]
      out[xy[0]].store(xy, val)
    end
    puts out.map { |row| (row[1].map { |_xy, val| val }).join(' ') }
    puts ''
  end


  def available_moves(pos = @knight_pos)
    moves_to_check = [
      [pos[0] - 2, pos[1] - 1],
      [pos[0] - 2, pos[1] + 1],
      [pos[0] + 2, pos[1] - 1],
      [pos[0] + 2, pos[1] + 1],
      [pos[0] - 1, pos[1] - 2],
      [pos[0] - 1, pos[1] + 2],
      [pos[0] + 1, pos[1] - 2],
      [pos[0] + 1, pos[1] + 2]
    ]
    available_moves = []
    moves_to_check.map { |move| available_moves.push(move) if @board.include?(move)}
    available_moves
  end

  def show_knight
    available_moves.map { |square| @board[square] = '■'.red }
    @board[@knight_pos] = "♞"
    print_board
    create_board
  end

  def move_knight(to)
    puts "#{@knight_pos} > #{to}"
    return puts 'illegal move' unless available_moves.include?(to)

    @knight_pos = to
    create_board
    show_knight
  end
end

class Node
  attr_accessor :data, :children, :parent

  def initialize(pos, parent = nil)
    @data = pos
    @parent = parent
    @children = []
  end
end

board = Board.new
board.knight_moves([1, 2], [7, 7])