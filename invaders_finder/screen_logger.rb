# frozen_string_literal: true

module InvadersFinder
  # Outputs log messages to the screen
  class ScreenLogger
    def initialize
      require 'rainbow' unless defined?(::Rainbow)
    end

    # @param text [String]
    # @param color [Symbol]
    # @return [nil]
    def log(text, color = :white)
      puts(Rainbow(text).send(color))
    end
  end
end
