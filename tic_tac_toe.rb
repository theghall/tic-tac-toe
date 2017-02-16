require "./game_bases"
require 'byebug'

module TicTacToe

	class TicTacToeBoard < GameBases::GameBoard

		def initialize
			super(3,3,".")
		end

	end

	class TicTacToePlayer < GameBases::Player

		attr_accessor :piece

		def initialize(name)

			super(name)

		end

		def take_turn(referee)

			print("Enter row: ")
			row = gets.chomp

			print("Enter col: ")
			col = gets.chomp

			referee.place_piece(self, row.to_i, col.to_i)

		end

	end

	class TicTacToeCompPlayer < GameBases::Player

		attr_accessor :piece

		def initialize
			super("Computer")
			@piece = "O"
		end

		def take_turn(board)
		end

	end

	class TicTacToeReferee < GameBases::Referee

		def initialize

			@min_players = 2
			@max_players = 2
			@players = Array.new
			@game_over = false
			@winners = Array.new
			@turn_number = 1
			@active_players = Array.new
			@passive_players = Array.new

		end

		def officiate(player)

			@board = TicTacToeBoard.new 

			@board.display

			player.piece=("X")
			@players << player

			comp_player = TicTacToeCompPlayer.new
			comp_player.piece=("O")
			@players << comp_player

			@active_players << @players[0]
			@passive_players << @players[1]

			while !@game_over

				@board.display

				@active_players[0].take_turn(self)

			end

		end

		def place_piece(player, row, col)

			@board.put_piece(row, col, player.piece)

		end

	end

end
