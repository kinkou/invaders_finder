# frozen_string_literal: true

module InvadersFinder
  # Calculates similarity between two text blocks
  class Comparator
    RESULT_SCALE = 3
    private_constant :RESULT_SCALE

    # @param text_block_a [InvadersFinder::TextBlock]
    # @param text_block_b [InvadersFinder::TextBlock]
    # @param similarity_algorithm [InvadersFinder::SimilarityAlgorithms::Base]
    def initialize(text_block_a, text_block_b, similarity_algorithm)
      @text_block_a = text_block_a
      @text_block_b = text_block_b
      @algorithm = similarity_algorithm
    end

    # @return [Float]
    # @raise [InvadersFinder::Comparator::InvalidDimensionsError]
    def execute
      data_a = @text_block_a.to_a
      data_b = @text_block_b.to_a
      similarity_per_pair = []

      data_a.size.times do |line|
        similarity_per_pair << @algorithm.compare(data_a[line], data_b[line])
      end

      calculate_total(similarity_per_pair)
    end

    private

    # @param similarity_per_pair [Array<Float>]
    # @return [Float]
    def calculate_total(similarity_per_pair)
      result = similarity_per_pair.reduce(:+) / similarity_per_pair.size
      result.round(RESULT_SCALE)
    end
  end
end
