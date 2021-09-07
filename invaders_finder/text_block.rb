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

    private

    # @return [Array<String>]
    def prepare
      @data = @data.downcase.lines.map(&:strip).reject(&:empty?)
    end
  end
end
