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

		def take_turn(referee, board)

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

		def take_turn(referee, board)

			avail_spaces = board.empty_spaces

			piece_pos = avail_spaces[rand(avail_spaces.length)]

			referee.place_piece(self, piece_pos[0],piece_pos[1])

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

		def have_winner?

			false

		end

		def board_full?

			board_full = true

			@board.board.each do |row|
				board_full &&= !row.include?(@board.fill_char)
			end

			board_full

		end

		def officiate(player)

			@board = TicTacToeBoard.new 

			player.piece=("X")
			@players << player

			comp_player = TicTacToeCompPlayer.new
			comp_player.piece=("O")
			@players << comp_player

			@active_players << @players[0]
			@passive_players << @players[1]

			have_winner = false
			board_full = false

			while !@game_over

				@board.display

				@active_players[0].take_turn(self, @board)
				
				@active_players[0], @passive_players[0] = @passive_players[0], @active_players[0]


				have_winner = have_winner?
				board_full = board_full?

				@game_over = have_winner || board_full

			end

			if have_winner
				puts("We have a winner!")
			else
				puts("No winner!")
			end

		end

		def place_piece(player, row, col)

			@board.put_piece(row, col, player.piece)

		end

	end

end
