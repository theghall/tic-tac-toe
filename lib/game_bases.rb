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
			@board[row][col] = char
		end

		def reset
			@board.each do |row|

				row.fill(@fill_char)

			end
		end
		
		# Returns 2d array of empty space row, col pairs
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
			
		def space_empty?(row, col)
			space_empty = false

			if row.between?(0, @board_rows - 1) && col.between?(0, @board_cols - 1)

				space_empty = @board[row][col] == fill_char

			end

			space_empty
		end

	end	

	class Referee
		
	end

	class Player
		
		def initialize(name)

		end

	end
end
