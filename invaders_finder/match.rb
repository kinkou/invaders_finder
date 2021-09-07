# frozen_string_literal: true

module InvadersFinder
  # Knows everything about the scan match
  class Match
    # @param image [Array<String>]
    # @param similarity [Float]
    # @param offset_x [Integer]
    # @param offset_y [Integer]
    def initialize(image, similarity, offset_x, offset_y)
      @image = image
      @similarity = similarity
      @offset_x = offset_x
      @offset_y = offset_y
    end

    # @return [nil]
    def log
      LOGGER.log(@image.join("\n"), :cyan)
      LOGGER.log("Similarity: ~#{@similarity}%", :yellow)
      LOGGER.log("Y: #{@offset_y}", :yellow)
      LOGGER.log("X: #{@offset_x}", :yellow)
      LOGGER.log("\n")
    end
  end
end
