# frozen_string_literal: true

module InvadersFinder
  module SimilarityAlgorithms
    # Pluggable Damerau-Levenshtein algorithm
    class Levenshtein < Base
      THRESHOLD = 0.65
      private_constant :THRESHOLD

      def initialize
        require 'damerau-levenshtein' unless defined?(::DamerauLevenshtein)
      end

      # @result [Float]
      def threshold
        THRESHOLD
      end

      # @param string_a [String]
      # @param string_b [String]
      # @return [Float] Similarity between two strings in the range of [0.0, 1.0]
      def compare(string_a, string_b)
        result = ::DamerauLevenshtein.distance(string_a, string_b)
        result = 1 if result.zero?
        (1.0 / result).round(RESULT_SCALE)
      end
    end
  end
end
