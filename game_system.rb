#game_system.rb
#
# Simple wrapper to play tic tac toe
#
# 20170218 GH
#
require './tic_tac_toe'

puts("Welcome to TicTacToe Thunderdome!!!!\n\n")

print("Please enter your name: ")
name = gets.chomp

print("\n\n")

play = true

player = TicTacToe::TicTacToePlayer.new(name)
referee = TicTacToe::TicTacToeReferee.new

while play

	referee.officiate(player)

	print("Play again?: (Y/N): ")

	answer = gets.chomp

	answer.downcase!

	play = (answer == "y" ? true: false)

	referee.new_game

end 

puts("\n\n")
puts("#{player.name}, thanks for playing!")
