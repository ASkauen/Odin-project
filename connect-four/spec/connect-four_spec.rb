# frozen_string_literal: true

require_relative '../lib/connect-four'
include Resources

describe ConnectFour do
  describe '#place_color' do
    context 'when placing in full col' do
      subject(:game_full_col) { described_class.new }
      before do
        6.times { game_full_col.place_color(0) }
      end
      it 'returns false' do
        expect(game_full_col.place_color(0)).to be(false)
      end

      it 'does not change @placed_colors' do
        expect { game_full_col.place_color(0) }.not_to change { game_full_col.placed_colors }
      end

      it 'does not update turn' do
        turn = game_full_col.instance_variable_get(:@turn)
        expect { game_full_col.place_color(0) }.not_to change { turn }
      end
    end

    context 'when placing in non-full col' do
      subject(:game_avlbl_col) { described_class.new }
      before { game_avlbl_col.instance_variable_set(:@board, NEW_BOARD) }
      context 'returns next players turn' do
        it 'returns Player 2 when turn is Player 1' do
          expect(game_avlbl_col.place_color(0)).to eql('Player 2')
        end
        it 'returns Player 1 when turn is Player 2' do
          game_avlbl_col.instance_variable_set(:@turn, 'Player 2')
          expect(game_avlbl_col.place_color(0)).to eql('Player 1')
        end
      end

      context 'adds correct color to col' do
        it 'adds red to col when turn is Player 1' do
          expect { game_avlbl_col.place_color(0) }.to change { game_avlbl_col.placed_colors[0] }.from([]).to([RED])
        end

        it 'adds blue to col when turn is Player 2' do
          game_avlbl_col.place_color(0)
          expect { game_avlbl_col.place_color(0) }.to change {
                                                        game_avlbl_col.placed_colors[0]
                                                      }.from([RED]).to([RED, BLUE])
        end
      end

      it 'updates the boards' do
        expect(game_avlbl_col).to receive(:update_boards)
        game_avlbl_col.place_color(0)
      end

      it 'updates the turn' do
        expect(game_avlbl_col).to receive(:update_turn)
        game_avlbl_col.place_color(0)
      end
    end
  end

  describe '#update_boards' do
    subject(:game_board) { described_class.new }
    before do
      game_board.instance_variable_set(:@board, NEW_BOARD)
      game_board.update_boards
    end
    it 'sends #format_board' do
      expect(game_board).to receive(:format_board)
      game_board.update_boards
    end

    context 'updates boards' do
      before do
        game_board.instance_variable_set(:@placed_colors, [[RED], [], [], [], [], [], []])
      end
      it '@formatted_board' do
        formatted_board = game_board.instance_variable_get(:@formatted_board)
        expect(game_board.update_boards).not_to eql(formatted_board)
      end
      it '@board' do
        board = game_board.instance_variable_get(:@board)
        expect { game_board.update_boards }.to change { board }
      end
    end
  end

  describe '#play' do
    subject(:game_play) { described_class.new }
    before do
      allow(game_play).to receive(:get_input)
      allow(game_play).to receive(:update_boards)
      allow(game_play).to receive(:print_board)
      allow(game_play).to receive(:place_color)
      allow(game_play).to receive(:end_message)
      allow(game_play).to receive(:game_over?).and_return('Player 1')
    end
    it 'sends #place_color' do
      expect(game_play).to receive(:place_color)
      game_play.play
    end
    it 'sends #update_boards' do
      expect(game_play).to receive(:update_boards)
      game_play.play
    end
    it 'sends #print_boards' do
      expect(game_play).to receive(:print_board)
      game_play.play
    end
    it 'sends #game_over?' do
      allow(game_play).to receive(:game_over?).and_return(true)
      expect(game_play).to receive(:game_over?)
      game_play.play
    end
    it 'runs again if #game_over? is false' do
      allow(game_play).to receive(:game_over?).and_return(false, true)
      expect(game_play).to receive(:game_over?).twice
      game_play.play
    end
    it 'sends end_message if #game_over? returns winner' do
      allow(game_play).to receive(:game_over?).and_return('Player 1')
      expect(game_play).to receive(:end_message)
      game_play.play
    end
  end

  describe '#get_input' do
    subject(:game_input) { described_class.new }
    before do
      allow(game_input).to receive(:print)
      allow(game_input).to receive(:gets)
    end
    context 'prints instructions with turn' do
      context 'when turn is Player 1' do
        it 'prints "Player 1, Pick a column (0-6)":' do
          message = "Player 1, Pick a column (0-6):\n"
          allow(game_input).to receive(:valid_input?).and_return(true)
          expect(game_input).to receive(:print).with(message)
          game_input.get_input
        end
      end
      context 'when turn is Player 2' do
        it 'prints "Player 2, Pick a column (0-6)":' do
          game_input.instance_variable_set(:@turn, "Player 2")
          message = "Player 2, Pick a column (0-6):\n"
          allow(game_input).to receive(:valid_input?).and_return(true)
          expect(game_input).to receive(:print).with(message)
          game_input.get_input
        end
      end
    end
    it 'loops when input is invalid' do
      allow(game_input).to receive(:valid_input?).and_return(false, 1)
      expect(game_input).to receive(:valid_input?).twice
      game_input.get_input
    end
    it 'returns input when input is valid' do
      allow(game_input).to receive(:valid_input?).and_return(1)
      expect(game_input.get_input).to eq(1)
    end
  end

  describe '#valid_input?' do
    subject(:game_valid) { described_class.new }
    it 'returns false when given letter' do
      expect(game_valid.valid_input?('f')).to be(false)
    end
    it 'returns false when given symbol' do
      expect(game_valid.valid_input?('!')).to be(false)
    end
    it 'returns false when given int out of range 0-6' do
      expect(game_valid.valid_input?('8')).to be(false)
    end
    it 'returns int of valid input' do
      expect(game_valid.valid_input?('3')).to eql(3)
    end
  end

  describe '#game_over?' do
    subject(:check_game_over) { described_class.new }
    it 'returns false when no checks return a winner' do
      allow(check_game_over).to receive(:winner).and_return(false, false, false)
      allow(check_game_over).to receive(:tie?).and_return(false)
      expect(check_game_over.game_over?).to be(false)
    end
    context 'win on row' do
      it 'returns name of winner' do
        allow(check_game_over).to receive(:winner).and_return('Player 1', false, false)
        allow(check_game_over).to receive(:tie?).and_return(false)
        expect(check_game_over.game_over?).to eql('Player 1')
      end
    end
    context 'win on col' do
      it 'returns name of winner' do
        allow(check_game_over).to receive(:winner).and_return(false, 'Player 1', false)
        allow(check_game_over).to receive(:tie?).and_return(false)
        expect(check_game_over.game_over?).to eql('Player 1')
      end
    end
    context 'win on diagonal' do
      it 'returns name of winner' do
        allow(check_game_over).to receive(:winner).and_return(false, false, 'Player 1')
        allow(check_game_over).to receive(:tie?).and_return(false)
        expect(check_game_over.game_over?).to eql('Player 1')
      end
    end
    context 'tie' do
      it 'returns "tie"' do
        allow(check_game_over).to receive(:winner).and_return(false, false, false)
        allow(check_game_over).to receive(:tie?).and_return('tie')
        expect(check_game_over.game_over?).to eql('tie')
      end
      it 'returns winner if #winner and #tie? return truthy' do
        allow(check_game_over).to receive(:winner).and_return(false, 'Player 1', false)
        allow(check_game_over).to receive(:tie?).and_return('tie')
        expect(check_game_over.game_over?).to eql('Player 1')
      end
    end
  end

  describe '#winner' do
    subject(:game_winner) { described_class.new }
    no_win = [[EMPTY, RED, RED, EMPTY, BLUE, EMPTY]]
    red_win = [[EMPTY, RED, RED, RED, RED, EMPTY]]
    blue_win = [[EMPTY, BLUE, BLUE, BLUE, BLUE, EMPTY]]
    it 'returns false when no winner' do
      expect(game_winner.winner(no_win)).to be(false)
    end
    it 'returns Player 1 when player1 wins' do
      expect(game_winner.winner(red_win)).to eql('Player 1')
    end
    it 'returns Player 2 when player2 wins' do
      expect(game_winner.winner(blue_win)).to eql('Player 2')
    end
  end

  describe '#diags_to_check' do
    subject(:game_diags) { described_class.new }
    it 'returns merged array of all diagonals' do
      allow(game_diags).to receive(:get_diags).and_return([[1], [2]], [[3], [4]], [[5], [6]], [[7], [8]])
      expect(game_diags.diags_to_check).to eql([[1], [2], [3], [4], [5], [6], [7], [8]])
    end
  end
end
