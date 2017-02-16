require 'byebug'

module GameBases

	class GameBoard
		attr_accessor :board_rows, :board_cols, :board, :fill_char

		def initialize(num_rows, num_cols, fill_char)

			@fill_char = fill_char
			@board_rows = num_rows
			@board_cols = num_cols

			@board = Array.new(board_rows, @fill_char) {Array.new(board_cols, @fill_char)}

		end

		def display

			@board.each do |row|
				puts row.each { |c| c }.join(" ")
			end
			
		end

		def put_piece(row, col, char)

			@board[row][col] = char

		end

		def reset_board

			@board.each do |row|
				row.fill(@fill_char)
			end

		end
		
		def empty_spaces

			empty_spaces = []

			@board.each_with_index do |outer, row|

				outer.each_with_index do |inner, col|

					if inner == fill_char
					
						space = [row, col]

						empty_spaces <<	space

					end

				end

			end

			empty_spaces

		end
			
	end	

	class Referee
		
		attr_accessor :board, :min_players, :max_players, :players, :game_over, :winners, \
			:turn_number, :active_players, :passive_players

	end

	class Player
		
		attr_accessor :name

		def initialize(name)
			@name = name
		end

	end
end
