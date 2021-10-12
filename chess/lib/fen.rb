# frozen_string_literal: true

require 'json'

class Fen
  attr_accessor :placement, :turn, :castling, :en_passant, :half_move, :full_move

  def initialize(board)
    @board = board
    @placement = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'
    @turn = 'w'
    @castling = 'KQkq'
    @en_passant = '-'
    @half_move =  0
    @full_move =  1
  end

  def set_rooks
    @QR = @board.get_piece([1, 1]) || nil
    @KR = @board.get_piece([8, 1]) || nil
    @qr = @board.get_piece([8, 1]) || nil
    @kr = @board.get_piece([8, 8]) || nil
  end

  def load(file_name)
    file = File.open("./saves/#{file_name}.json", 'r')
    JSON.parse(file.read).each do |var, value|
      instance_variable_set(var.to_sym, value)
    end
    file.close
  end

  def get_save_name()
    available_saves = Dir.entries("./saves").select {|s| s.end_with?(".json")}.map {|s| s = s[0...-5]}
    if available_saves.empty?
        print("\nNo save files found, starting new game\n")
        return false
    end
    save_to_load = ""

    print("\nAvailable saves:\n")
    puts available_saves

    until available_saves.include?(save_to_load)
        print("\nChoose a save to load: ")
        save_to_load = gets.chomp.downcase
        print "\nSave not found\n" unless available_saves.include?(save_to_load)
    end

    return save_to_load.downcase
end

  def save(file_name)
    out = {}
    [:@placement, :@turn, :@castling, :@en_passant, :@half_move, :@full_move].each do |var|
      out[var] = instance_variable_get var
    end
    file = File.new("./saves/#{file_name}.json", 'w')
    file.write(out.to_json)
    file.close
  end

  def update_all(ep_square)
    enemy_pieces = @turn == 'w' ? @board.black_pieces : @board.white_pieces
    update_turn
    update_placement
    update_en_passant(ep_square)
    update_castling
    ep_caturable = enemy_pieces.map {|p| p.legal_moves.include?(en_passant)}.any?
    fen_string = [placement, @turn, @castling, ep_caturable].join(" ")
    @board.previous_positions << fen_string
  end

  def update_turn
    @turn = @turn == 'w' ? 'b' : 'w'
  end

  def update_placement
    out = []
    @board.split_to_rows.each_value do |row|
      blank = 0
      section = []
      row.each_value do |p|
        if [W_SQUARE, B_SQUARE].include?(p)
          blank += 1
        else
          section << blank if blank.positive?
          section << ICONS.key(p)
          blank = 0
        end
      end
      section << blank if blank.positive?
      out << section.join('')
    end
    @placement = out.join('/')
  end

  def update_en_passant(square)
    @en_passant = square || '-'
  end

  def update_castling
    @castling = @castling.gsub('KQ', '') if @board.white_king.has_moved
    @castling = @castling.gsub('Q', '') if @QR.has_moved
    @castling = @castling.gsub('K', '') if @KR.has_moved
    @castling = @castling.gsub('kq', '') if @board.black_king.has_moved
    @castling = @castling.gsub('q', '') if @qr.has_moved
    @castling = @castling.gsub('k', '') if @kr.has_moved
    @castling = '-' if @castling == ''
  end
end
