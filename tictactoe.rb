class TicTacToe
    attr_reader :player1
    attr_reader :player2

    def initialize(player1, player2)
        @player1 = player1.to_s
        @player2 = player2.to_s
        @player2 += "2" if @player1 == @player2
        @player_turn = @player1
    end


    def start_new()
        @board = [
                [["."], ["."], ["."]], 
                [["."], ["."], ["."]],
                [["."], ["."], ["."]]
            ]
        print_board()
    end

    def print_board()
        print "    ---------\n"
        @board.each {|l| print("    | #{l.flatten.join(" ")} |\n")}
        print "    ---------\n"
    end

    def play_round(placement)
        return puts ("Invalid number") unless (1..9).to_a.include?(placement.to_i)
        placement = placement.to_i
        symbol = @player_turn == @player1 ? "X" : "O"
        row = ((3 * ((placement. + 3 - 1) / 3)) / 3) - 1
        col = row == 0 ? (placement - 1) : row == 1 ? (placement - 4) : (placement - 7)
        if @board[row][col] == ["."]
            @board[row][col] = symbol
            @player_turn = symbol == "X" ? @player2 : @player1
        else
            return puts "Spot taken"
        end
        print_board()
    end

    def winner()
        return check_row()if check_row() 
        return check_col() if check_col() 
        return check_diag() if check_diag() 
        return false if @board.flatten.include?(".")
        return "tie"
    end

    def check_row()
        @board.each do |r|
            if r.uniq.size == 1
                return r[0] if r[0] != ["."]
            end
        end
        return false
    end

    def check_col()
        3.times do |i|
            col = []
            3.times do |r|
                col.push(@board[r][i])
            end
            if col.uniq.length == 1
                return col[1][0] if col[1][0] != "."
            end
        end
        return false
    end

    def check_diag()
        if [@board[0][0], @board[1][1], @board[2][2]].uniq.length == 1
            return @board[0][0] if @board[0][0] != ["."]
        elsif [@board[0][2], @board[1][1], @board[2][0]].uniq.length == 1
            return @board[0][2] if @board[0][2] != ["."]
        end
        return false
    end
end

def play()
    puts "Enter player names:"
    game = TicTacToe.new(gets.chomp, gets.chomp)
    print "#{game.player1}(X) vs. #{game.player2}(O)\n"
    game.start_new()
    while game.winner == false
        print "Choose 1-9: "
        game.play_round(gets)
    end
    case game.winner()
    when "X"
        print "#{game.player1} wins!\n"
    when "O"
        print "#{game.player2} wins!\n"
    else
        print "Tie!\n"
    end
    play()
end

play()