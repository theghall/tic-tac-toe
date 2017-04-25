#game_bases.rb
#
# This file contains base classes for consistent behavior for all grid based
# board games.  class Referee contains instance variables that are most likely
# to be consistent across grid board games
#

module GameBases

	class GameBoard
		attr_accessor :board_rows, :board_cols, :board, :fill_char

		def initialize(num_rows, num_cols, fill_char)
			@fill_char = fill_char

			@board_rows = num_rows

			@board_cols = num_cols

			@board = Array.new(board_rows) {Array.new(board_cols, @fill_char)}

		end

		def display
			@board.each do |row|
				puts row.each { |c| c }.join(" ")
			end

			print("\n\n")
		end

		def put_piece(row, col, char)


		end

		def reset


		end
		
		# Returns 2d array of empty space row, col pairs
		def empty_spaces

		end
			
		def space_empty?(row, col)

		end

	end	

	class Referee
		
	end

	class Player
		
		def initialize(name)

		end

	end
end
