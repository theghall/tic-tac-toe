#game_system.rb
#
# Simple wrapper to play tic tac toe
#
# 20170218 GH
#
require './lib/tic_tac_toe'

puts("Welcome to TicTacToe Thunderdome!!!!\n\n")

print("Player1, Please enter your name: ")
name = gets.chomp

print("\n\n")

got_players = false

while !got_players

	print("How many players (0,1,2)? ")

	num_players = gets.chomp

	num_players = num_players.to_i

	got_players = [0,1,2].include?(num_players)

end

case num_players
when 0
  player1 = TicTacToe::TicTacToeCompPlayer.new('X', 'Joshua')
  player2 = TicTacToe::TicTacToeCompPlayer.new('O', 'HAL')
when 1
  player1 = TicTacToe::TicTacToePlayer.new('X', name)
  player2 = TicTacToe::TicTacToeCompPlayer.new('O', 'Josuha')
when 2
  player1 = TicTacToe::TicTacToePlayer.new('X', name)

  print("Player2, Please enter your name: ")
  name = gets.chomp

  player2 = TicTacToe::TicTacToePlayer.new('O', name)
end

referee = TicTacToe::TicTacToeReferee.new

play = true

while play

	referee.officiate(player1, player2)

	print("Play again?: (Y/N): ")

	answer = gets.chomp

	answer.downcase!

	play = (answer == "y" ? true: false)

	referee.new_game

end 

puts("\n\n")
puts("#{name}, thanks for playing!")
