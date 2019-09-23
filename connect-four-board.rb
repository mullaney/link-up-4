require 'colorize'
require 'minitest/autorun'
require 'io/console'

ROWS = 6
COLS = 7
RED = 'Red'.freeze
BLACK = 'Black'.freeze

module ConnectFour
  # The connect four 'board': a grid for placing checkers
  class Board
    attr_accessor :grid
    def initialize
      @grid = Array.new(COLS) { Array.new(ROWS) }
    end

    def drop_checker(column, color)
      first_empty = @grid[column].find_index(nil)
      return false unless first_empty
      @grid[column][first_empty] = color
    end

    def game_won
    end

    def show
      puts '                         '.on_white
      (0...ROWS).each do |row|
        printf '  '.on_white
        row = (0...COLS).map do |col|
          square = @grid[col][ROWS - 1 - row]
          if square == RED
            red_square
          elsif square == BLACK
            black_square
          else
            empty_square
          end
        end.join
        printf row
        puts '  '.on_white
      end
      puts '   1  2  3  4  5  6  7   '.black.on_white
      puts '                         '.on_white
    end

    def empty_square
      ' ● '.colorize(:light_gray).on_yellow
    end

    def red_square
      ' ● '.colorize(:red).on_yellow
    end

    def black_square
      ' ● '.colorize(:black).on_yellow
    end
  end

  # Player for connect four
  class Player
    attr_reader :color
    def initialize(color)
      @color = color
    end
  end

  # Handles gameplay
  class Game
    attr_reader :current_player
    def initialize
      @board = Board.new
      @current_player = BLACK
    end

    def switch_player
      @current_player = @current_player == BLACK ? RED : BLACK
    end

    def clear
      system("clear") || system("cls")
    end

    def start_message
      '  Welcome to Link Up 4!  '.black.on_white + "\n" +
      '  Black goes first.      '.black.on_white
    end

    def turn_message
      "  It is #{@current_player}'s turn.      ".slice(0, 25).black.on_white + "\n" +
      "  Choose a column, 1-#{COLS}.   ".slice(0, 25).black.on_white + "\n" +
      "  Press Q to quit.       ".black.on_white

    end

    def blank_white
      '                         '.black.on_white
    end

    def start
      clear
      puts blank_white
      puts start_message
      turn_loop
    end

    def turn
      @board.show
      puts turn_message
      puts blank_white
      STDIN.getch
    end

    def column_full
      puts blank_white
      puts '  That column is full.   '.black.on_white
      puts '  Try another column.    '.black.on_white
    end

    def turn_loop
      loop do
        input = turn
        break if (input == 'Q' || input == 'q')
        if (input.to_i >= 1 && input.to_i <= COLS)
          column = input.to_i - 1
          success = @board.drop_checker column, @current_player
          if success
            switch_player
            clear
          else
            clear
            column_full
          end
        end
      end
    end
  end
end

game = ConnectFour::Game.new
game.start

# Testing Board
class TestConnectFourBoard < MiniTest::Test
  def setup
    @board = ConnectFour::Board.new
  end

  def test_board_contains_a_grid
    assert_instance_of Array, @board.grid
  end

  def test_grid_has_correct_number_of_columns
    assert_equal @board.grid.length, COLS
  end

  def test_grid_has_correct_number_of_rows
    assert_equal @board.grid[0].length, ROWS
  end

  def test_drop_checker_add_colored_checker_to_column
    @board.drop_checker 0, RED
    @board.drop_checker 0, BLACK
    @board.drop_checker 0, BLACK
    assert_equal @board.grid[0], [RED, BLACK, BLACK, nil, nil, nil]
  end
end

# Testing Player
class TestConnectFourPlayer < MiniTest::Test
  def setup
    @player = ConnectFour::Player.new(RED)
  end

  def test_player_has_a_color
    assert @player.color, RED
  end
end

class TestConnectFourGame < MiniTest::Test
  def setup
    @game = ConnectFour::Game.new
  end

  def test_has_a_current_player_which_starts_as_black
    assert_equal @game.current_player, BLACK
  end

  def test_switch_player_toggles_current_player
    @game.switch_player
    assert_equal @game.current_player, RED
  end
end
