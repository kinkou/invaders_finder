# frozen_string_literal: true

module InvadersFinder
  # Searches for an invader in the radar's sample data
  class Scanner
    # @param sample [InvadersFinder::TextBlock]
    # @param pattern [InvadersFinder::TextBlock]
    # @param similarity_algorithm [InvadersFinder::SimilarityAlgorithms::Base]
    def initialize(sample, pattern, similarity_algorithm)
      @pattern = pattern
      @setup = ScannerSetup.new(sample, pattern)
      @padded_sample = sample.pad(@setup.horizontal_pad_size, @setup.vertical_pad_size)
      @algorithm = similarity_algorithm
    end

    # @return [Array<InvadersFinder::Match>, nil]
    def execute
      results = []

      @setup.steps_down.times do |offset_y|
        @setup.steps_right.times do |offset_x|
          match = scan_at(offset_x, offset_y)
          results << match if match
        end
      end

      results
    end

    private

    # @param offset_x [Integer]
    # @param offset_y [Integer]
    # @return [InvadersFinder::Match]
    def scan_at(offset_x, offset_y) # rubocop:disable Metrics/MethodLength
      subsample = @padded_sample.subsample_at(offset_x, offset_y, @setup.frame_width, @setup.frame_height) # rubocop:disable Layout/LineLength
      comparator = Comparator.new(subsample, @pattern, @algorithm)
      similarity = comparator.execute
      if similarity >= @algorithm.threshold # rubocop:disable Style/GuardClause
        Match.new(
          subsample.unpad.to_a,
          @algorithm.to_percent(similarity),
          @setup.unpad_offset_x(offset_x),
          @setup.unpad_offset_y(offset_y)
        )
      end
    end
  end
end
