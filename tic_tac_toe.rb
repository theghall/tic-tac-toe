#tic_tac_toe.rb
#
#
# Tic Tac Toe is a two player game played on a 3 x 3 grid.  Each player takes
# turns placing their pieces on the board in an empty space.  One player uses
# 'X' and player uses 'O'.   The first player to get three of their pieces in 
# a row vertically or horizontally, or diagonally wins. If all the spaces in 
# the grid are filled before anyone gets three in a row vertically or hori-
# zontally,  or diagonally the game is over
#
# This module works with a human player and a computer player
#
# 20170217	GH
#
require "./game_bases"

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

			good_move = false

			while !good_move

				print("Enter row: ")
				row = gets.chomp

				print("Enter col: ")
				col = gets.chomp

				good_move = referee.place_piece(self, row.to_i - 1, col.to_i - 1)

			end

		end

	end

	class TicTacToeCompPlayer < GameBases::Player

		attr_accessor :piece, :level

		def initialize
			super("Computer")
			@piece = "O"
			@level = 1
		end

		def take_turn(referee, board)

			case @level
			when 0
				level_zero(referee, board)
			when 1
				level_one(referee, board)
			else
				#should not happen, but default to lowest level
				level_zero(referee, board)
			end

		end

		private

		def level_zero(referee, board)

			avail_spaces = board.empty_spaces

			piece_pos = avail_spaces[rand(avail_spaces.length)]

			referee.place_piece(self, piece_pos[0],piece_pos[1])

		end

		def block_in_row?(referee, board)

			block_in_row = false

			board.board.each_with_index do |outer, o|

				opp_pieces = outer.each_with_index.select {|p,i| p == (@piece == "X" ? "O": "X") }

				empty_spaces = outer.each_with_index.select {|p,i| p == board.fill_char}

				if opp_pieces.length == 2 && empty_spaces.length == 1

					referee.place_piece(self, o, empty_spaces[0][1])

					block_in_row = true

					break if block_in_row

				end

			end

			block_in_row
			
		end

		def block_in_col?(referee, board)

			block_in_col = false

			opp_pieces = Array.new(board.board_rows)
			empty_spaces = Array.new(board.board_rows)

			board.board.each_with_index do |outer, o|

				opp_pieces[o] = (outer.each_with_index.select {|p,i| p == (@piece == "X" ? "O": "X") })

			end

			# This will not block at 3,2 or 3,3 if 1,1 and 2,1 were blocked at 3,1
			# Also, since row is blocked first, if 1,3 and 2,3 were blocked by row
			# then it will not block at 3,1 or 3,2. 
			for i in 0..1 do

			  union = opp_pieces[0 + i]&(opp_pieces[1 + i])
			
				if union.length != 0

					row = (i == 0 ? 2: 3)

					col = union[0][1]

					block_in_col = true if board.space_empty?(row, col)

					break if block_in_col

				end

			end

			referee.place_piece(self, row, col) if block_in_col

			block_in_col

		end

		def block_diagonally?(referee, board)

			block_diagonally = false

			opp_piece = (@piece == "X" ? "O": "X")

			# No need to check if opponent does not control center
			if board.board[1][1] == opp_piece

				 corner_pieces_r1 = board.board[0].each_with_index.select \
					 {|p, i| p == opp_piece && (i == 0 || i == 2)}

				 corner_pieces_r2 = board.board[1].each_with_index.select \
					 {|p, i| p == opp_piece && (i == 0 || i == 2)}

				
				# Since row is checked first it should never be 2
				if corner_pieces_r1.length == 1

					#block opposite corner
					row = 2

					col = corner_pieces_r1[0][1] == 0 ? 2: 0

					block_diagonally = true

				elsif corner_pieces_r2.length == 1

					#block opposite corner
					row = 0

					col = corner_pieces_r2[0][1] == 0 ? 2: 0

					block_diagonally = true

				end

			end

			referee.place_piece(self, row, col) if block_diagonally

			block_diagonally

		end

		def level_one(referee, board)

			if !block_in_row?(referee, board)

				if !block_in_col?(referee, board)

					if !block_diagonally?(referee, board)

						# If no block just do random choice
						level_zero(referee, board)

					end

				end

			end

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


			have_winner = false
			board_full = false

			set_players(player)

			set_level(player)

			while !@game_over

				@board.display

				@active_players[0].take_turn(self, @board)

				have_winner = have_winner?(@active_players[0].piece)

				board_full = board_full?

				@game_over = have_winner || board_full

				@active_players[0], @passive_players[0] = @passive_players[0], @active_players[0] if !@game_over

			end

			display_game_results(have_winner)

		end

		def place_piece(player, row, col)

			valid_move = valid_move?(player, row, col)

			if valid_move

				puts("#{player.name} plays '#{player.piece}' on #{row + 1}, #{col + 1}")

				@board.put_piece(row, col, player.piece)

			end

			if player.name == "Computer" && !valid_move

				puts("Internal error: computer tried a move on #{row + 1}, #{col + 1}")

			end

			valid_move

		end

		private


		def valid_move?(player, row, col)

			valid_move = row.between?(0,2) && col.between?(0,2)
			
			if valid_move

					valid_move &&= @board.space_empty?(row, col)

					print("#{player.name}, please select an empty space.\n\n") if !valid_move

			else

				print("#{player.name}, please enter a valid row and column.\n\n")

			end

			valid_move

		end

		def choose_piece(player)

			piece = "X"

			got_piece = false

			while !got_piece

				print("#{player.name}, choose your piece ('X' or 'O'): ")
				piece = gets.chomp

				got_piece = piece == "X" || piece == "O"

				print("Please choose a valid piece.\n\n") if !got_piece

			end

			piece

		end

		def set_level(player)

			got_level = false

			while !got_level

				print("#{player.name}, choose the computer play level (E)asy or (T)urbo: ")
				level = gets.chomp

				level.downcase!

				got_level = true

				case level
				when "e"
					@level = 1
				when "t"
					@level = 2
				else
					print("Please select a valid option.\n\n")
					got_level = false
				end

			end

		end

		def set_players(player)

			@board = TicTacToeBoard.new 

			player.piece = choose_piece(player)

			@players << player

			comp_player = TicTacToeCompPlayer.new

			player.piece == "X" ? comp_player.piece = "O": comp_player.piece = "X"

			@players << comp_player

			@active_players.push(player.piece == "X" ? player: comp_player)

			@passive_players.push(player.piece == "O" ? player: comp_player)

		end

		def display_game_results(have_winner)

			@board.display

			if have_winner
				puts("#{active_players[0].name} is the winner!")
			else
				puts("No winner!")
			end

		end

		def row_wins?(piece)
			
			winner = false

			for x in 0..2

				num_in_col = @board.board.flatten.each_with_index.select \
					{|p,i| p == piece && (i == 0 + x || i == 3 + x || i == 6 + x) }.length

				winner = (num_in_col == 3)

				break if winner

			end

			winner

		end

		def col_wins?(piece)

			winner = false

			for x in 0..2 

				num_in_row = @board.board.flatten.each_with_index.select \
					{|p,i| p == piece && i.between?(0 + (x * 3) , 2 + (x * 3))}.length

				winner = (num_in_row == 3)

				break if winner

			end

			winner

		end

		def diagonal_wins?(piece)

			winner = false

			for x in 0..2

				num_in_diagonal = @board.board.flatten.each_with_index.select \
					{|p,i| p == piece && (i == (0 + x) || i == 4 || i == (8 - x)) }.length

				winner = (num_in_diagonal == 3)

				break if winner

			end

			winner

		end

		def have_winner?(piece)

			winner = false

			winner ||= row_wins?(piece)
			
			winner ||= col_wins?(piece)

			winner ||= diagonal_wins?(piece)

			winner

		end

		def board_full?

			board_full = true

			@board.board.each do |row|
				board_full &&= !row.include?(@board.fill_char)
			end

			board_full

		end

	end

end
