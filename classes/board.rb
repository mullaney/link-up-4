require 'minitest/autorun'
require_relative 'output'

module LinkUpFour
  COLS = 7
  ROWS = 6

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

    def to_s
      str = []
      str.push(Output.new('').output_one_line)
      (0...ROWS).each do |row|
        row_output = ''
        (0...COLS).each do |col|
          square = @grid[col][ROWS - 1 - row]
          if square == :red
            row_output += red_square
          elsif square == :black
            row_output += black_square
          else
            row_output += empty_square
          end
        end
        str.push(Output.new(row_output, variable_border: false, colorize_line: false).output_one_line)
      end
      str.push(Output.new(' 1  2  3  4  5  6  7 ').output_one_line)
      str.push(Output.new('').output_one_line)
      str.join("\n")
    end

    def empty_square
      options = {
        color: :light_white, background: :yellow, border: 1, length: 3
      }
      Output.new('●', options).output_one_line
    end

    def red_square
      options = {
        color: :red, background: :yellow, border: 1, length: 3
      }
      Output.new('●', options).output_one_line
    end

    def black_square
      options = {
        color: :black, background: :yellow, border: 1, length: 3
      }
      Output.new('●', options).output_one_line
    end
  end
end

board = LinkUpFour::Board.new
board.drop_checker(1, :red)
board.drop_checker(1, :black)

puts board.to_s

# Testing Board
class TestLinkUpFourBoard < MiniTest::Test
  def setup
    @board = LinkUpFour::Board.new
  end

  def test_board_contains_a_grid
    assert_instance_of Array, @board.grid
  end

  def test_grid_has_correct_number_of_columns
    assert_equal @board.grid.length, LinkUpFour::COLS
  end

  def test_grid_has_correct_number_of_rows
    assert_equal @board.grid[0].length, LinkUpFour::ROWS
  end

  def test_drop_checker_add_colored_checker_to_column
    @board.drop_checker 0, :red
    @board.drop_checker 0, :black
    @board.drop_checker 0, :black
    assert_equal @board.grid[0], [:red, :black, :black, nil, nil, nil]
  end
end
