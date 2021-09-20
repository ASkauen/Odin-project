require_relative '../lib/tictactoe.rb'

describe TicTacToe do
  describe '#check_col' do
    subject(:game_col) {described_class.new(1, 2)}
    before do
      game_col.board = [
        [['X'], ['.'], ['.']],
        [['X'], ['.'], ['.']],
        [['X'], ['.'], ['.']]
      ]
    end
    it 'returns X when 3 Xs in a col' do
      response = game_col.check_col
    end
  end
end