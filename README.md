Tic Tac Toe is a two player game played on a 3 x 3 grid.  Each player takes
turns placing their pieces on the board in an empty space.  One player uses
'X' and player uses 'O'.  The player who has 'X' goes first. The first 
player to get three of their pieces in a row vertically or horizontally, or 
diagonally wins. If all the spaces in the grid are filled before anyone gets
three in a row vertically or horizontally,  or diagonally the game is over

This module works with a human player and a computer player

The computer player can either be set to pick a random
empty space, or do simple blocking (first found)

To use you need to create a TicTacToePlayer object
and a TicTacToeReferee object.  Then the game can
be played as follows:
<TicTacToeReferee object>.officiate(<TicTacToePlayer object>)

To start a new game with an existing TicTacToeReferee then
use <TicTacToeReferee object>.new_game then call officiate


game_system.rb is a quick and dirty wrapper around
the classes

