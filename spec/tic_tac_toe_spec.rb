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

  describe '.put_piece' do
    let(:board) { TicTacToe::TicTacToeBoard.new }

    context "Calling put_piece(0,0,'X')" do
      it "displays an 'X' at 0,0" do
        board.put_piece(0, 0, 'X')
        expect { board.display }.to output(/X \. \.\n\. \. \.\n\. \. \.\n/).to_stdout
      end
    end
  end

  describe '.reset' do
    let(:board) { TicTacToe::TicTacToeBoard.new }

    context "Calling reset after calling put_piece((0,0,'X')" do
      it "displays an empty board" do
        board.put_piece(0, 0, 'X')
        board.reset
        expect { board.display }.to output(/\. \. \.\n\. \. \.\n\. \. \.\n/).to_stdout
      end
    end
  end

  describe ".empty_spaces" do

    let(:board) { TicTacToe::TicTacToeBoard.new }

    context "Calling empty_spaces after calling put_piece(0,0,'X')" do
      it "returns a 2d array of all empty spaces. less 0,0" do
        board.put_piece(0, 0, 'X')
        expect(board.empty_spaces).to eql([[0,1],[0,2],[1,0],[1,1],[1,2],[2,0],[2,1],[2,2]])
      end
    end
  end

  describe ".space_empty?" do

    let(:board) { TicTacToe::TicTacToeBoard.new }
        
    context "calling space_empty(0,0) on a empty board" do
      it "returns true" do
        expect(board.space_empty?(0,0)).to eql(true)
      end
    end

    context "calling space_empty(0,0) after put_piece(0,0,'X')" do
      it "returns false" do
        board.put_piece(0, 0, 'X')
        expect(board.space_empty?(0,0)).to eql(false)
      end
   end
  end
end
