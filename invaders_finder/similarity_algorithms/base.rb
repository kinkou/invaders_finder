# frozen_string_literal: true

module InvadersFinder
  # Namespace for similarity algorithms
  module SimilarityAlgorithms
    RESULT_SCALE = 3
    PERCENTAGE_SCALE = 1
    private_constant :RESULT_SCALE, :PERCENTAGE_SCALE

    # @abstract Base class for all similarity algorithms
    class Base
      # @param similarity [Float]
      # @return [Float]
      def to_percent(similarity)
        (similarity * 100).round(PERCENTAGE_SCALE)
      end
    end
  end
end
