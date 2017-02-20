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

got_players = false

while !got_players

	print("How many players (0,2)? ")

	num_players = gets.chomp

	num_players = num_players.to_i

	got_players = [0,2].include?(num_players)

end

player = num_players == 2 ? TicTacToe::TicTacToePlayer.new(name): TicTacToe::TicTacToeCompPlayer.new("Joshua")
referee = TicTacToe::TicTacToeReferee.new

play = true

while play

	referee.officiate(player)

	print("Play again?: (Y/N): ")

	answer = gets.chomp

	answer.downcase!

	play = (answer == "y" ? true: false)

	referee.new_game

end 

puts("\n\n")
puts("#{name}, thanks for playing!")
