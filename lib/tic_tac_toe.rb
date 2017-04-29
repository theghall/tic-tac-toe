require './lib/game_bases'

module TicTacToe
  class TicTacToeBoard < GameBases::GameBoard

   def initialize
     super(3, 3, '.')
   end

  end

  class TicTacToePlayer < GameBases::Player

    def initialize(name)
      super(name)
    end

    def take_turn(referee, board)
    end
  end
end
