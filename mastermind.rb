require "colorize"
require "pry"

module Resources
    CODE_COLORS = {
        RED: "⬤".red,
        GREEN:"⬤".green,
        BLUE: "⬤".blue,
        YELLOW: "⬤".yellow,
        CYAN: "⬤".cyan,
        MAGENTA: "⬤".magenta
    }

    BLACK = "●".black
    WHITE = "●".white

    COLOR_CHOICES = ("
Color choices:
    #{CODE_COLORS[:RED]}  1
    #{CODE_COLORS[:GREEN]}  2
    #{CODE_COLORS[:BLUE]}  3
    #{CODE_COLORS[:YELLOW]}  4
    #{CODE_COLORS[:CYAN]}  5
    #{CODE_COLORS[:MAGENTA]}  6
                    ")
    
    NUMBER_TO_COLOR = {1 => :RED, 2 => :GREEN, 3 => :BLUE, 4 => :YELLOW, 5 => :CYAN, 6  => :MAGENTA}


end

class MasterMind
    attr_accessor :turn

    include Resources

    def initialize(player_role)
        @player_role = player_role.chomp.downcase
        @turn = 1

        if @player_role == "b"
            @code = generate_code()
            puts "Code generated"
            until player_guess();end

        elsif @player_role == "m"
            created_code = false

            until created_code 
                created_code = create_code()
            end

            @code = created_code

            computer_guess()
        end

    end

    private
    def input_valid?(input)
        colors = input.map {|i| i = NUMBER_TO_COLOR[i.to_i]}
        colors.map do |c|
            unless CODE_COLORS.include?(c) and input.size == 4
                print "\n\n\nInput Error\n\n\n"
                sleep 1
                return false
            end
        end
        return true
    end

    private
    def generate_code()
        code = []
        4.times do
            sample = CODE_COLORS.keys.sample
            CODE_COLORS.select { |k,v| k == sample }  
            code.push(sample)
        end
        code
    end

    private
    def create_code()
        puts COLOR_CHOICES
        puts "Choose 4 colors: "
        code_input = gets.chomp.split("")
        return false unless input_valid?(code_input)
        player_code = code_input.map {|s| s = CODE_COLORS[NUMBER_TO_COLOR[s.to_i]]}
        puts "\nYour code is: \n#{player_code.join("  ")}\n\n"
        return player_code
    end

    private
    def player_guess()
        puts COLOR_CHOICES
        puts "Round #{@turn}/12"
        print "Guess: "
        guess = gets.chomp!.split("")
        return false unless input_valid?(guess)
        guess = guess.map {|g| g = NUMBER_TO_COLOR[g.to_i]}
        print "\n Your guess:\n #{(guess.map {|c| c = CODE_COLORS[c]}).join("  ")}\n"
        @turn += 1
        if guess == @code
            print "\n\nBreaker wins\n\n" 
            return true
        end
        if @turn == 13
            print("\n\nMaker wins\n\n Code was:\n #{(@code.map {|c| c = CODE_COLORS[c]}.join("  "))}\n\n")
            return true 
        end
        print "\nHint:\n#{hint(guess, @code).join("  ")}\n"
    end

    private
    def computer_guess()
        possible_codes = (1111..6666).to_a.reject {|n| n.to_s.count("7890") > 0}
        guess = possible_codes.sample
        until false or @turn == 13
            guess_colors = guess.to_s.split("").map {|g| g = NUMBER_TO_COLOR[g.to_i]}
            puts "Round #{@turn}/12"
            print "\nComputer's guess:\n#{guess_colors.map {|c| c = CODE_COLORS[c]}.join("  ")}\n"
            computer_hint = hint(guess_colors.map {|c| c = CODE_COLORS[c]}, @code)
            if computer_win?(guess)
                print "\n\nBreaker wins\n\n"
                return
            end

            print "\nHint:\n#{computer_hint.join("  ")}\n\n"

            possible_codes = possible_codes.reject {|code| computer_hint != hint(guess.to_s.split(""), code.to_s.split(""))}
            guess = possible_codes.sample
            @turn += 1
            sleep 1
        end
    end

    private
    def computer_win?(guess)
        guess.to_s.split("").map {|c| c = CODE_COLORS[NUMBER_TO_COLOR[c.to_i]]} == @code
    end

    private
    def hint(guess, compare)
        hint = []
        code = compare.clone
        guess.each_index do |i|
            if guess[i] == code[i]
                hint.push(BLACK)
                code[i] = nil
                guess[i] = ""
            end
        end
        guess.each_index do |i|
            if code.include?(guess[i])
                hint.push(WHITE) 
                code[code.find_index(guess[i])] = nil
            end
        end
        
        hint
    end
end


def run()
    role = ""
    until role == "m" or role == "b"
        puts "Play as maker(M) og breaker(B)?"
        role = gets.chomp.downcase
    end
    game = MasterMind.new(role)
end


loop do
    run()
end