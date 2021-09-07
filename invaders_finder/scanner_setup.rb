# frozen_string_literal: true

module InvadersFinder
  # Calculates settings for the Scanner
  class ScannerSetup
    InvalidDimensionsError = Class.new(StandardError)

    # @param sample [InvadersFinder::TextBlock]
    # @param pattern [InvadersFinder::TextBlock]
    # @raise [InvadersFinder::ScannerSetup::InvalidDimensionsError]
    def initialize(sample, pattern)
      if sample.height < pattern.height || sample.width < pattern.width
        raise InvalidDimensionsError
      end

      @sample = sample
      @pattern = pattern
    end

    # @return [Integer]
    def frame_width
      @pattern.width
    end

    # @return [Integer]
    def frame_height
      @pattern.height
    end

    # @return [Integer]
    def horizontal_pad_size
      (@pattern.width / 2.0).ceil
    end

    # @return [Integer]
    def vertical_pad_size
      (@pattern.height / 2.0).ceil
    end

    # @return [Integer]
    def steps_right
      @sample.width + horizontal_pad_size * 2 - @pattern.width + 1
    end

    # @return [Integer]
    def steps_down
      @sample.height + vertical_pad_size * 2 - @pattern.height + 1
    end

    # @param offset_x [Integer]
    # @return [Integer]
    def unpad_offset_x(offset_x)
      offset_x - horizontal_pad_size + 1
    end

    # @param offset_y [Integer]
    # @return [Integer]
    def unpad_offset_y(offset_y)
      offset_y - vertical_pad_size + 1
    end
  end
end
