require './lib/game_bases'

module TicTacToe
  class TicTacToeBoard < GameBases::GameBoard

   def initialize
     super(3, 3, '.')
   end

  end

  class TicTacToePlayer < GameBases::Player
    attr_accessor :token

    def initialize(name, token)
      @token = token

      super(name)
    end

    def take_turn(referee, board)
      good_move = false

      while !good_move

        print("#{name},Enter pos [row, col]: ")
        pos = gets.chomp.split(',')

        row = pos[0]

        col = pos[1]

        good_move = referee.place_piece(self, row.to_i - 1, col.to_i - 1)
      end
   end
  end

  class CompTurnError < RuntimeError

    def initialize(msg="The computer player encountered an error.")
      
      super(msg)

    end

  end

  class TicTacToeCompPlayer < GameBases::Player
    PLAY_LEVEL_EASY = 0
    PLAY_LEVEL_TURBO = 1

    attr_accessor :piece, :level

    def initialize(name = "Computer")
      super(name)
      @piece = 'O'
      @level = PLAY_LEVEL_EASY
    end

    def take_turn(referee, board)

      case @level
      when PLAY_LEVEL_EASY

        level_easy(referee, board)

      when PLAY_LEVEL_TURBO

        level_turbo(referee, board)

      else
      
        # should not happen, but default to lowest level
        level_easy(referee, board)

      end

    end

    private

    def level_easy(referee, board)

      avail_spaces = board.empty_spaces

      piece_pos = avail_spaces[rand(avail_spaces.length)]

      referee.place_piece(self, piece_pos[0],piece_pos[1])

    end

    # Blocks if able and returns true if able
    def block_in_row?(referee, board)

      block_in_row = false

      board.board.each_with_index do |outer, o|

        opp_pieces = outer.each_with_index.select { |p,i| p == (@piece == 'X' ? 'O' : 'X') }

        empty_spaces = outer.each_with_index.select { |p,i| p == board.fill_char}

        if opp_pieces.length == 2 && empty_spaces.length == 1

          referee.place_piece(self, o, empty_spaces[0][1])

          block_in_row = true

          break if block_in_row

        end

      end

      block_in_row
      
    end

    # Blocks if able and returns true if able
    def block_in_col?(referee, board)

      block_in_col = false

      opp_pieces = Array.new(board.board_rows)
      empty_spaces = Array.new(board.board_rows)

      board.board.each_with_index do |outer, o|

        opp_pieces[o] = (outer.each_with_index.select { |p,i| p == (@piece == 'X' ? 'O' : 'X') })

      end

      # This will not block at 3,2 or 3,3 if 1,1 and 2,1 were blocked at 3,1
      # Also, since row is blocked first, if 1,3 and 2,3 were blocked by row
      # then it will not block at 3,1 or 3,2. 
      for i in 0..1 do

        union = opp_pieces[0 + i]&(opp_pieces[1 + i])
      
        if union.length != 0

          row = (i == 0 ? 2 : 3)

          col = union[0][1]

          block_in_col = true if board.space_empty?(row, col)

          break if block_in_col

        end

      end

      referee.place_piece(self, row, col) if block_in_col

      block_in_col

    end

    # Blocks if able and returns true if able
    def block_diagonally?(referee, board)
      block_diagonally = false

      opp_piece = (@piece == 'X' ? 'O' : 'X')

      # No need to check if opponent does not control center
      if board.board[1][1] == opp_piece
         corner_pieces_r1 = board.board[0].each_with_index.select \
           { |p, i| p == opp_piece && (i == 0 || i == 2)}

         corner_pieces_r2 = board.board[2].each_with_index.select \
           { |p, i| p == opp_piece && (i == 0 || i == 2)}


        # May not block, since the opposite corner may already be 
        # blocked
        if corner_pieces_r1.length > 0
          # block opposite corner
          row = 2

          col = corner_pieces_r1[0][1] == 0 ? 2 : 0

          block_diagonally = true if board.space_empty?(row, col)
        elsif corner_pieces_r2.length > 0
          # block opposite corner
          row = 0

          col = corner_pieces_r2[0][1] == 0 ? 2 : 0

          block_diagonally = true if board.space_empty?(row, col)
        end
      end

      referee.place_piece(self, row, col) if block_diagonally

      block_diagonally
    end

    def level_turbo(referee, board)
      if !block_in_row?(referee, board)
        if !block_in_col?(referee, board)
          if !block_diagonally?(referee, board)
            # If no block just do random choice
            level_easy(referee, board)
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
      @turn = 1
      @board = TicTacToe::TicTacToeBoard.new
      @active_players = Array.new
      @passive_players = Array.new

    end

    def officiate(player1, player2)

      @game_over = false

      winner = false

      board_full = false

      comp_level = player2.class == TicTacToe::TicTacToeCompPlayer ? get_level(player1) : nil
      
      setup_players(player1, player2, comp_level)

      while !@game_over

        @board.display

        begin

          @active_players[0].take_turn(self, @board)

        rescue CompTurnError=> e
    
          puts e.message

          puts("You can try and play again.")

          break

        end

        winner = winner?(@active_players[0].token)

        board_full = board_full?

        @game_over = winner || board_full

        @turn += 1 if !@game_over

        @active_players[0], @passive_players[0] = @passive_players[0], @active_players[0] if !@game_over

      end

      display_game_results(winner)

    end

    def new_game

      @players = Array.new
      @game_over = false
      @winners = Array.new
      @turn = 1
      @active_players = Array.new
      @passive_players = Array.new
      @board.reset

    end

    def place_piece(player, row, col)

      valid_move = valid_move?(player, row, col)

      if valid_move

        puts("#{player.name} plays '#{player.token}' on #{row + 1}, #{col + 1}")

        @board.put_piece(row, col, player.token)

      end

      valid_move
    end

    private

    def valid_move?(player, row, col)

      comp_player = (player.class == TicTacToe::TicTacToeCompPlayer)

      valid_move = row.between?(0,2) && col.between?(0,2)
      
      if valid_move

          valid_move &&= @board.space_empty?(row, col)

          print("#{player.name}, please select an empty space.\n\n") if !valid_move && !comp_player

      else

        print("#{player.name}, please enter a valid row and column.\n\n") if !comp_player

      end

      raise CompTurnError,  "Internal error : computer tried a move on #{row + 1}, #{col + 1}"  if comp_player && !valid_move

      valid_move

    end

    def get_level(player1)

      got_level = false

      if player1class == TicTacToe::TicTacToeCompPlayer

        level = TicTacToeCompPlayer::PLAY_LEVEL_TURBO

        got_level = true

      end

      while !got_level

        print("#{player1.name}, choose the computer play level (E)asy or (T)urbo : ")
        level_input = gets.chomp

        level_input.downcase!

        got_level = true

        case level_input
        when "e"

          level = TicTacToeCompPlayer::PLAY_LEVEL_EASY

        when "t"

          level = TicTacToeCompPlayer::PLAY_LEVEL_TURBO

        else

          print("Please select a valid option.\n\n")

          got_level = false

        end

      end

      level

    end

    def setup_players(player1, player2, comp_level)

      @board = TicTacToeBoard.new 

      player1.level = comp_level if player1.class == TicTacToe::TicTacToeCompPlayer

      player2.level = comp_level if player2.class == TicTacToe::TicTacToeCompPlayer

      @players << player1 << player2

      @active_players << player1

      @passive_players << player2

    end

    def display_game_results(winner)

      @board.display

      if winner
        puts("#{active_players[0].name} is the winner after #{@turn} turns!")
      else
        puts("No winner!")
      end

    end

    def row_wins?(piece)
      
      winner = false

      for x in 0..2

        num_in_col = @board.board.flatten.each_with_index.select \
          { |p,i| p == piece && (i == 0 + x || i == 3 + x || i == 6 + x) }.length

        winner = (num_in_col == 3)

        break if winner

      end

      winner

    end

    def col_wins?(piece)
      winner = false

      for x in 0..2 
        num_in_row = @board.board.flatten.each_with_index.select \
          { |p,i| p == piece && i.between?(0 + (x * 3) , 2 + (x * 3))}.length

        winner = (num_in_row == 3)

        break if winner
      end

      winner
    end

    def diagonal_wins?(piece)

      winner = false

      for x in 0..2

        num_in_diagonal = @board.board.flatten.each_with_index.select \
          { |p,i| p == piece && (i == (0 + x) || i == 4 || i == (8 - x)) }.length

        winner = (num_in_diagonal == 3)

        break if winner

      end

      winner

    end

    def winner?(piece)

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
