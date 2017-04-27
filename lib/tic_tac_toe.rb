require './lib/game_bases'

module TicTacToe
  class TicTacToeBoard < GameBases::GameBoard

   def initialize
     super(3, 3, '.')
   end

  end
end
