# frozen_string_literal: true

module InvadersFinder
  # Performs basic operations on a rectangular block of text
  class TextBlock
    # @param string [String]
    def initialize(string, name = nil)
      @data = string
      prepare
    end

    # @return [Array<String>]
    def to_a
      @data
    end

    # @return [Integer]
    def width
      to_a[0].length
    end

    # @return [Integer]
    def height
      to_a.size
    end

    # @return [Array<Integer>]
    def dimensions
      [width, height]
    end

    # @param horizontal_size [Integer]
    # @param vertical_size [Integer]
    # @return [InvadersFinder::TextBlock]
    def pad(horizontal_size, vertical_size) # rubocop:disable Metrics/MethodLength
      side_padding = PAD_CHAR * horizontal_size
      padded_data = to_a.map do |line|
        side_padding + line + side_padding
      end

      padded_data_width = padded_data[0].length
      pad_line = PAD_CHAR * padded_data_width

      vertical_size.times do
        padded_data.unshift(pad_line)
        padded_data.push(pad_line)
      end

      new_self(padded_data)
    end

    private

    # @return [Array<String>]
    def prepare
      @data = @data.downcase.lines.map(&:strip).reject(&:empty?)
    end

    # @param self_data [Array<String>]
    # @return [InvadersFinder::TextBlock]
    def new_self(self_data)
      self.class.new(self_data.compact.join(NEWLINE))
    end
  end
end
