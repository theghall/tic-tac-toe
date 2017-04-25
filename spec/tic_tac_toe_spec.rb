# tic_tac_toe_spec.rb
#
# 20170424	GH
#
require 'game_bases'
require 'tic_tac_toe'

describe "TicTacToeBoard" do

  describe "attributes" do

    let(:board) { TicTacToe::TicTacToeBoard.new }

    it { expect(board).to respond_to(:display) }
    it { expect(board).to respond_to(:put_piece) }
    it { expect(board).to respond_to(:reset) }
    it { expect(board).to respond_to(:empty_spaces) }
    it { expect(board).to respond_to(:space_empty?) }

  end

  describe '.display' do

    let(:board) { TicTacToe::TicTacToeBoard.new }

    context "given a TicTacToeBoard" do
      it "displays an empty board" do
        expect { board.display }.to output(/\. \. \.\n\. \. \.\n\. \. \.\n/).to_stdout
      end
    end
  end
end
