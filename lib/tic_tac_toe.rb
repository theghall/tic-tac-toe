require './lib/game_bases'

module TicTacToe
  class TicTacToeBoard < GameBases::GameBoard

   def initialize
     super(3, 3, '.')
   end

  end

  class TicTacToePlayer < GameBases::Player
    attr_accessor :token

    def initialize(name, token)
      @token = token

      super(name)
    end

    def take_turn(referee, board)
    end
  end

  class TicTacToeReferee < GameBases::Referee
    def initialize
    end

    def officiate(player1, player2)
    end

    def new_game
    end

    def place_piece(player, row, col)
    end
  end
end
