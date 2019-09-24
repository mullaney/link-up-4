require 'minitest/autorun'
require_relative 'board'

module LinkUpFour
  # Handles gameplay
  class Game
    attr_reader :current_player
    def initialize
      @board = Board.new
      @current_player = :black
    end

    def switch_player
      @current_player = @current_player == :black ? :red : :black
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

# Test game flow
class TestLinkUpFourGame < MiniTest::Test
  def setup
    @game = LinkUpFour::Game.new
  end

  def test_has_a_current_player_which_starts_as_black
    assert_equal @game.current_player, :black
  end

  def test_switch_player_toggles_current_player
    @game.switch_player
    assert_equal @game.current_player, :red
  end
end
