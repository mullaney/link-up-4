require 'colorized_string'

module LinkUpFour
  # Output a 1 line string
  class Output
    def initialize(line, options = {})
      @line = line
      @options = {
        length: 25,
        border: 2,
        background: :light_white,
        color: :black,
        colorize_line: true,
        variable_border: true
      }.merge(options)
    end

    def output_one_line
      left_border + middle + right_border
    end

    def left_border
      ColorizedString[' ' * @options[:border]].colorize(
        color: @options[:color],
        background: @options[:background]
      )
    end

    def middle
      if @options[:colorize_line] == true
        return ColorizedString[@line].colorize(
          color: @options[:color],
          background: @options[:background]
        )
      end
      @line
    end

    def right_border
      ColorizedString[' ' * right_border_length].colorize(
        color: @options[:color],
        background: @options[:background]
      )
    end

    def right_border_length
      return @options[:border] unless @options[:variable_border]
      @options[:length] - @line.length - @options[:border]
    end
  end
end
