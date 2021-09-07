# frozen_string_literal: true

module InvadersFinder
  # Calculates settings for the Scanner
  class ScannerSetup
    InvalidDimensionsError = Class.new(StandardError)

    # @param sample [InvadersFinder::TextBlock]
    # @param pattern [InvadersFinder::TextBlock]
    # @raise [InvadersFinder::ScannerSetup::InvalidDimensionsError]
    def initialize(sample, pattern)
      if sample.height != pattern.height || sample.width != pattern.width
        raise InvalidDimensionsError
      end

      @sample = sample
      @pattern = pattern
    end
  end
end
