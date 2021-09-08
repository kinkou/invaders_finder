# frozen_string_literal: true

module InvadersFinder
  # Performs basic operations on a rectangular block of text
  class TextBlock
    InvalidDimensionsError = Class.new(StandardError)

    attr_reader :name

    # @param string [String]
    # @param name [Symbol]
    def initialize(string, name = nil)
      @data = string
      @name = name
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

    # @return [InvadersFinder::TextBlock]
    def unpad
      new_data = to_a.map { |line| line.delete(PAD_CHAR) }.reject(&:empty?)
      new_self(new_data)
    end

    # @param offset_x [Integer]
    # @param offset_y [Integer]
    # @param columns [Integer]
    # @param lines [Integer]
    # @return [InvadersFinder::TextBlock]
    def subsample_at(offset_x, offset_y, columns, lines)
      subsample = []

      lines.times do |line_number|
        line = to_a[offset_y + line_number]
        subsample << line.slice(offset_x, columns) if line
      end

      new_self(subsample)
    end

    # @param text_block [InvadersFinder::TextBlock]
    # @return [Array<InvadersFinder::TextBlock>]
    # @raise [InvadersFinder::TextBlock::InvalidDimensionsError]
    def intersect_with(text_block) # rubocop:disable Metrics/AbcSize
      raise InvalidDimensionsError if dimensions != text_block.dimensions

      # @note #dup creates a shallow copy which means that the strings
      # in the original objects will also be mutated:
      # a = ['test']
      # b = a.dup
      # b[0][0] = 'n'
      # p a #=> ['nest']
      data_a = to_a.dup
      data_b = text_block.to_a.dup

      height.times do |line|
        width.times do |column|
          data_a[line][column] = PAD_CHAR if data_b[line][column] == PAD_CHAR
          data_b[line][column] = PAD_CHAR if data_a[line][column] == PAD_CHAR
        end
      end

      [data_a, data_b].map { |item| new_self(item).unpad }
    end

    private

    # @return [Array<String>]
    def prepare
      @data = @data.downcase.lines.map(&:strip).reject(&:empty?)
    end

    # @param self_data [Array<String>]
    # @param self_name [Symbol]
    # @return [InvadersFinder::TextBlock]
    def new_self(self_data, self_name = @name)
      self.class.new(self_data.compact.join(NEWLINE), self_name)
    end
  end
end
