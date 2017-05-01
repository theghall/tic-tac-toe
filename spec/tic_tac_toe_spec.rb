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

describe "TicTacToePlayer" do

  describe "attributes" do

    let(:aplayer) { TicTacToe::TicTacToePlayer.new('John','X') }

    it { expect(aplayer).to respond_to(:name) }
    it { expect(aplayer).to respond_to(:token) }
    it { expect(aplayer).to respond_to(:take_turn) }
  end

  describe ".name" do

    let(:aplayer) { TicTacToe::TicTacToePlayer.new('John','X') }

    context "Create player with name 'John' and call .name" do
      it "returns 'John' as name" do
        expect(aplayer.name).to eql('John')
      end
    end

    context "Create player with token 'X' and call .token" do
      it "returns 'X'" do
        expect(aplayer.token).to eql('X')
      end
    end
  end
end

describe "TicTacToeReferee" do

  describe "attributes" do

    let (:areferee) { TicTacToe::TicTacToeReferee.new }

    it { expect(areferee).to respond_to(:officiate) }
    it { expect(areferee).to respond_to(:new_game) }
    it { expect(areferee).to respond_to(:place_piece) }
  end

  describe ".place_piece" do

    let (:player1) { TicTacToe::TicTacToePlayer.new('John', 'X') }
    let (:player2) { TicTacToe::TicTacToePlayer.new('Jane', 'O') }
    let (:areferee) { TicTacToe::TicTacToeReferee.new }

    context "Player1 puts piece on 0,3" do
      it "returns false" do
        expect(areferee.place_piece(player1,0,3)).to eql(false)
      end
    end

    context "Player1 puts piece on 3,0" do
      it "returns false" do
        expect(areferee.place_piece(player1,3,0)).to eql(false)
      end
    end

    context "Player1 puts piece on -1,0" do
      it "returns false" do
       expect(areferee.place_piece(player1,-1,0)).to eql(false)
      end
    end

    context "Player1 puts piece on 0,-1" do
      it "returns false" do
        expect(areferee.place_piece(player1,0,-1)).to eql(false)
      end
    end

    context "Player1 puts piece on 0,0 on empty board" do
      it "returns true" do
        expect(areferee.place_piece(player1,0,0)).to eql(true)
      end
    end

    context "Player1 puts piece on 0,0 on board with token on 0,0" do
      it "returns false" do
        place_piece(player1,0,0)
        expect(areferee.place_piece(player2,0,0)).to eql(false)
      end
    end
  end
end
