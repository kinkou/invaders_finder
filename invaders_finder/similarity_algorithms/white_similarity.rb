# frozen_string_literal: true

module InvadersFinder
  module SimilarityAlgorithms
    # Pluggable White Similarity algorithm
    class WhiteSimilarity < Base
      THRESHOLD = 0.82
      private_constant :THRESHOLD

      def initialize
        require 'whitesimilarity' unless defined?(::WhiteSimilarity)
      end

      # @result [Float]
      def threshold
        THRESHOLD
      end

      # @param string_a [String]
      # @param string_b [String]
      # @return [Float] Similarity between two strings in the range of [0.0, 1.0]
      def compare(string_a, string_b)
        result = ::WhiteSimilarity.similarity(string_a, string_b)
        result.round(RESULT_SCALE)
      end
    end
  end
end
