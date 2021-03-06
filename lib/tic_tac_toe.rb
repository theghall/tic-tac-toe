require './lib/game_bases'

module TicTacToe
  # Simply creates a 3 x 3 board
  class TicTacToeBoard < GameBases::GameBoard
    def initialize
      super(3, 3, '.')
    end
  end

  # Allows human player to interact with Referee
  class TicTacToePlayer < GameBases::Player
    attr_accessor :token

    def initialize(token, name)
      @token = token

      super(name)
    end

    def take_turn(referee, _board)
      good_move = false

      until good_move

        print("#{name},Enter pos [row, col]: ")
        pos = gets.chomp.split(',')

        row = pos[0]

        col = pos[1]

        good_move = referee.place_token(self, row.to_i - 1, col.to_i - 1)
      end
    end
  end

  # If computer player generates bad game state
  class CompTurnError < RuntimeError
    def initialize(msg = 'The computer player encountered an error.')
      super(msg)
    end
  end

  # Allows computer player to interact with Referee
  class TicTacToeCompPlayer < GameBases::Player
    PLAY_LEVEL_EASY = 0
    PLAY_LEVEL_TURBO = 1

    attr_accessor :token, :level

    def initialize(token, name = 'Computer')
      super(name)

      @token = token

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

      token_pos = avail_spaces[rand(avail_spaces.length)]

      referee.place_token(self, token_pos[0], token_pos[1])
    end

    # Blocks if able and returns true if able
    def block_in_row?(referee, board)
      block_in_row = false

      opp_token = (@token == 'X' ? 'O' : 'X')

      board.board.each_with_index do |outer, o|
        opp_tokens = outer.each.select { |p| p == opp_token }

        empty_spaces = outer.each_with_index.select { |p, i| p == board.fill_char }

        if opp_tokens.length == 2 && empty_spaces.length == 1
          referee.place_token(self, o, empty_spaces[0][1])

          block_in_row = true

          break if block_in_row
        end
      end

      block_in_row
    end

    # Blocks if able and returns true if able
    def block_in_col?(referee, board)
      row = nil

      col = nil

      block_in_col = false

      opp_token = (@token == 'X' ? 'O' : 'X')

      opp_tokens = Array.new(board.board_rows)

      # Each space in a row with an opponents token will be selected
      # Stored with each token is the column in which the token is found
      board.board.each_with_index do |outer, o|
        opp_tokens[o] = outer.each_with_index.select { |p, i| p == opp_token }
      end

      # Find all opponent tokens in a column by means of a union
      # Since row is blocked first, if 1,3 and 2,3 were blocked by row
      # then it will not block at 3,1 or 3,2.
      # :TODO Instead of loop do 2 unions to see which row to block in
      # :TODO Split check for block in column to another method
      (0..1).each do |i|
        union = opp_tokens[0 + i] & (opp_tokens[1 + i])

        unless union.empty?

          row = (i.zero? ? 2 : 3)

          col = union[0][1]

          block_in_col = true if board.space_empty?(row, col)

          break if block_in_col
        end
      end

      referee.place_token(self, row, col) if block_in_col

      block_in_col
    end

    # Blocks if able and returns true if able
    def block_diagonally?(referee, board)
      block_diagonally = false

      opp_token = (@token == 'X' ? 'O' : 'X')

      # No need to check if opponent does not control center
      if board.board[1][1] == opp_token
        corner_tokens_r1 = board.board[0].each_with_index.select \
          { |p, i| p == opp_token && (i.zero? || i == 2) }

        corner_tokens_r2 = board.board[2].each_with_index.select \
          { |p, i| p == opp_token && (i.zero? || i == 2) }


        # May not block, since the opposite corner may already be
        # blocked
        if !corner_tokens_r1.empty?
          # block opposite corner
          row = 2

          col = corner_tokens_r1[0][1].zero? ? 2 : 0

          block_diagonally = true if board.space_empty?(row, col)
        elsif !corner_tokens_r2.empty?
          # block opposite corner
          row = 0

          col = corner_tokens_r2[0][1].zero? ? 2 : 0

          block_diagonally = true if board.space_empty?(row, col)
        end
      end

      referee.place_token(self, row, col) if block_diagonally

      block_diagonally
    end

    def level_turbo(referee, board)
      unless block_in_row?(referee, board)
        unless block_in_col?(referee, board)
          unless block_diagonally?(referee, board)
            # If no block just do random choice
            level_easy(referee, board)
          end
        end
      end
    end
  end

  # Checks for legal moves
  class TicTacToeReferee < GameBases::Referee
    def initialize
      @min_players = 2

      @max_players = 2

      @players = []

      @game_over = false

      @winners = []

      @turn = 1

      @board = TicTacToe::TicTacToeBoard.new

      @active_players = []

      @passive_players = []
    end

    def officiate(player1, player2)
      setup_players(player1, player2)

      until game_over
        @board.display

        active_player_turn

        winner = winner?(@active_players[0].token)

        @game_over = winner || board_full?

        @turn += 1 unless @game_over

        unless @game_over
          @active_players[0], @passive_players[0] =  \
            @passive_players[0], @active_players[0]
        end
      end

      display_game_results(winner)
    end

    def active_player_turn
      begin
        @active_players[0].take_turn(self, @board)
      rescue CompTurnError => e
        puts e.message

        puts('You can try and play again.')

        exit
      end
    end

    def new_game
      @players = []

      @game_over = false

      @winners = []

      @turn = 1

      @active_players = []

      @passive_players = []

      @board.reset
    end

    def place_token(player, row, col)
      valid_move = valid_move?(player, row, col)

      if valid_move

        puts("#{player.name} plays '#{player.token}' on #{row + 1}, #{col + 1}")

        @board.put_token(row, col, player.token)

      end

      valid_move
    end

    private

    def valid_move?(player, row, col)
      comp_player = (player.class == TicTacToe::TicTacToeCompPlayer)

      valid_move = row.between?(0, 2) && col.between?(0, 2)

      print("#{player.name}, please enter a valid row and column.\n\n") \
        if !valid_move && !comp_player

      valid_move &&= @board.space_empty?(row, col)

      print("#{player.name}, please select an empty space.\n\n") \
        if !valid_move && !comp_player

      if comp_player && !valid_move
        raise CompTurnError, \
              "Internal error : computer tried a move on #{row + 1}, #{col + 1}"
      end

      valid_move
    end

    def choose_level(player)
      got_level = false

      until got_level
        print("#{player.name}, \
          choose the computer play level (E)asy or (T)urbo : ")

        level_input = gets.chomp.downcase

        got_level = true

        case level_input
        when 'e'
          level = TicTacToeCompPlayer::PLAY_LEVEL_EASY
        when 't'
          level = TicTacToeCompPlayer::PLAY_LEVEL_TURBO
        else
          print("Please select a valid option.\n\n")

          got_level = false
        end
      end

      level
    end

    def get_level(player1)
      if player1.class == TicTacToe::TicTacToeCompPlayer
        TicTacToeCompPlayer::PLAY_LEVEL_TURBO
      else
        choose_level(player1)
      end
    end

    def setup_players(player1, player2)
      if player2.class == TicTacToe::TicTacToeCompPlayer
        player2.level = get_level(player1)

        if player1.class == TicTacToe::TicTacToeCompPlayer
          player1.level = player2.level
        end
      end

      @players << player1 << player2

      @active_players << player1

      @passive_players << player2
    end

    def display_game_results(winner)
      @board.display

      if winner
        puts("#{active_players[0].name} is the winner after #{@turn} turns!")
      else
        puts('No winner!')
      end
    end

    def row_wins?(token)
      winner = false

      (0..2).each do |x|
        num_in_col = @board.board.flatten.each_with_index.select do |p, i|
          p == token && (i == 0 + x || i == 3 + x || i == 6 + x)
        end

        winner = (num_in_col.length == 3)

        break if winner
      end

      winner
    end

    def col_wins?(token)
      winner = false

      (0..2).each do |x|
        num_in_row = @board.board.flatten.each_with_index.select do |p, i|
          p == token && i.between?(0 + (x * 3), 2 + (x * 3))
        end

        winner = (num_in_row.length == 3)

        break if winner
      end

      winner
    end

    def diagonal_wins?(token)
      winner = false

      (0..2).each do |x|
        num_in_diagonal = @board.board.flatten.each_with_index.select do |p, i|
          p == token && (i == (0 + x) || i == 4 || i == (8 - x))
        end

        winner = (num_in_diagonal.length == 3)

        break if winner
      end

      winner
    end

    def winner?(token)
      winner = false

      winner ||= row_wins?(token)

      winner ||= col_wins?(token)

      winner ||= diagonal_wins?(token)

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
