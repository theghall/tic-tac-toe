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
    it { expect(board).to respond_to(:put_token) }
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

  describe '.put_token' do
    let(:board) { TicTacToe::TicTacToeBoard.new }

    context "Calling put_token(0,0,'X')" do
      it "displays an 'X' at 0,0" do
        board.put_token(0, 0, 'X')
        expect { board.display }.to output(/X \. \.\n\. \. \.\n\. \. \.\n/).to_stdout
      end
    end
  end

  describe '.reset' do
    let(:board) { TicTacToe::TicTacToeBoard.new }

    context "Calling reset after calling put_token((0,0,'X')" do
      it "displays an empty board" do
        board.put_token(0, 0, 'X')
        board.reset
        expect { board.display }.to output(/\. \. \.\n\. \. \.\n\. \. \.\n/).to_stdout
      end
    end
  end

  describe ".empty_spaces" do

    let(:board) { TicTacToe::TicTacToeBoard.new }

    context "Calling empty_spaces after calling put_token(0,0,'X')" do
      it "returns a 2d array of all empty spaces. less 0,0" do
        board.put_token(0, 0, 'X')
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

    context "calling space_empty(0,0) after put_token(0,0,'X')" do
      it "returns false" do
        board.put_token(0, 0, 'X')
        expect(board.space_empty?(0,0)).to eql(false)
      end
   end
  end
end

describe "TicTacToePlayer" do

  describe "attributes" do

    let(:aplayer) { TicTacToe::TicTacToePlayer.new('X','John') }

    it { expect(aplayer).to respond_to(:name) }
    it { expect(aplayer).to respond_to(:token) }
    it { expect(aplayer).to respond_to(:take_turn) }
  end

  describe ".name" do

    let(:aplayer) { TicTacToe::TicTacToePlayer.new('X','John') }

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
    it { expect(areferee).to respond_to(:place_token) }
  end

  describe ".place_token" do

    let (:player1) { TicTacToe::TicTacToePlayer.new('X','John') }
    let (:player2) { TicTacToe::TicTacToePlayer.new('O','Jane') }
    let (:areferee) { TicTacToe::TicTacToeReferee.new }

    context "Player1 puts token on 0,3" do
      it "returns false" do
        expect(areferee.place_token(player1,0,3)).to eql(false)
      end
    end

    context "Player1 puts token on 3,0" do
      it "returns false" do
        expect(areferee.place_token(player1,3,0)).to eql(false)
      end
    end

    context "Player1 puts token on -1,0" do
      it "returns false" do
       expect(areferee.place_token(player1,-1,0)).to eql(false)
      end
    end

    context "Player1 puts token on 0,-1" do
      it "returns false" do
        expect(areferee.place_token(player1,0,-1)).to eql(false)
      end
    end

    context "Player1 puts token on 0,0 on empty board" do
      it "returns true" do
        expect(areferee.place_token(player1,0,0)).to eql(true)
      end
    end

    context "Player1 puts token on 0,0 on board with token on 0,0" do
      it "returns false" do
        areferee.place_token(player1,0,0)
        expect(areferee.place_token(player2,0,0)).to eql(false)
      end
    end
  end

  describe ".officiate" do

    let (:player1) { TicTacToe::TicTacToePlayer.new('X','John') }
    let (:player2) { TicTacToe::TicTacToePlayer.new('O','Jane') }
    let (:areferee) { TicTacToe::TicTacToeReferee.new }

    context "Player1 puts 3 in a row in row 1" do

      it "Displays 'John is the winner'" do
        allow(player1).to receive(:gets).and_return('1,1','1,2','1,3')
        allow(player2).to receive(:gets).and_return('2,1','2,2')

        expect{areferee.officiate(player1,player2)}.to output(/X X X\nO O \.\n\. \. \.\n\n\nJohn is the winner/).to_stdout
      end
    end

    context "Player1 puts 3 in a row in row 2" do

      it "Displays 'John is the winner'" do
        allow(player1).to receive(:gets).and_return('2,1','2,2','2,3')
        allow(player2).to receive(:gets).and_return('3,1','3,2')

        expect{areferee.officiate(player1,player2)}.to output(/\. \. \.\nX X X\nO O \.\n\n\nJohn is the winner/).to_stdout
      end
    end

    context "Player1 puts 3 in a row in row 3" do

      it "Displays 'John is the winner'" do
        allow(player1).to receive(:gets).and_return('3,1','3,2','3,3')
        allow(player2).to receive(:gets).and_return('2,1','2,2')

        expect{areferee.officiate(player1,player2)}.to output(/\. \. \.\nO O \.\nX X X\n\n\nJohn is the winner/).to_stdout
      end
    end

    context "Player1 puts 3 in a row in col 1" do

      it "Displays 'John is the winner'" do
        allow(player1).to receive(:gets).and_return('1,1','2,1','3,1')
        allow(player2).to receive(:gets).and_return('1,2','2,2')

        expect{areferee.officiate(player1,player2)}.to output(/X O \.\nX O \.\nX \. \.\n\n\nJohn is the winner/).to_stdout
      end
    end

    context "Player1 puts 3 in a row in col 2" do

      it "Displays 'John is the winner'" do
        allow(player1).to receive(:gets).and_return('1,2','2,2','3,2')
        allow(player2).to receive(:gets).and_return('1,3','2,3')

        expect{areferee.officiate(player1,player2)}.to output(/\. X O\n. X O\n\. X \.\n\n\nJohn is the winner/).to_stdout
      end
    end

    context "Player1 puts 3 in a row in col 3" do

      it "Displays 'John is the winner'" do
        allow(player1).to receive(:gets).and_return('1,3','2,3','3,3')
        allow(player2).to receive(:gets).and_return('1,2','2,2')

        expect{areferee.officiate(player1,player2)}.to output(/\. O X\n\. O X\n\. \. X\n\n\nJohn is the winner/).to_stdout
      end
    end

    context "Player1 puts 3 in a row diagonally from top left" do

      it "Displays 'John is the winner'" do
        allow(player1).to receive(:gets).and_return('1,1','2,2','3,3')
        allow(player2).to receive(:gets).and_return('2,1','3,1')

        expect{areferee.officiate(player1,player2)}.to output(/X \. \.\nO X \.\nO \. X\n\n\nJohn is the winner/).to_stdout
      end
    end

    context "Player1 puts 3 in a row diagonally from top right" do

      it "Displays 'John is the winner'" do
        allow(player1).to receive(:gets).and_return('1,3','2,2','3,1')
        allow(player2).to receive(:gets).and_return('2,1','1,1')

        expect{areferee.officiate(player1,player2)}.to output(/O \. X\nO X \.\nX \. \.\n\n\nJohn is the winner/).to_stdout
      end
    end

    context "Player1 and Player2 place tokens for a draw" do

      it "Displays 'Game is a draw'" do
        allow(player1).to receive(:gets).and_return('1,1','2,1','1,3','3,2','3,3')
        allow(player2).to receive(:gets).and_return('2,2','3,1','1,2','2,3')

        expect{areferee.officiate(player1,player2)}.to output(/X O X\nX O O\nO X X\n\n\nNo winner/).to_stdout
      end
    end
  end

  describe ".new_game" do

    let (:player1) { TicTacToe::TicTacToePlayer.new('X','John') }
    let (:player2) { TicTacToe::TicTacToePlayer.new('O','Jane') }
    let (:areferee) { TicTacToe::TicTacToeReferee.new }

    context "After a game is played, call .new_game" do
      it "is ready to start a new game" do
        allow(player1).to receive(:gets).and_return('1,1','1,2','2,1','3,2','2,3')
        allow(player2).to receive(:gets).and_return('2,2','1,3','3,1','3,3')
        areferee.officiate(player1, player2)
        areferee.new_game

        expect(areferee.players).to eql([])
        expect(areferee.game_over).to eql(false)
        expect(areferee.winners).to eql([])
        expect(areferee.turn).to eql(1)
        expect(areferee.active_players).to eql([])
        expect(areferee.passive_players).to eql([])
        expect{areferee.board.display}.to output(/\. \. \.\n\. \. \.\n\. \. \.\n/).to_stdout
       end
    end
  end
end
