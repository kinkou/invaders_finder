# frozen_string_literal: true

# Top-level namespace for the app
module InvadersFinder
  require 'yaml'

  require_relative 'invaders_finder/text_block.rb'
  require_relative 'invaders_finder/similarity_algorithms/base.rb'
  require_relative 'invaders_finder/similarity_algorithms/levenshtein.rb'
  require_relative 'invaders_finder/similarity_algorithms/white_similarity.rb'
  require_relative 'invaders_finder/comparator.rb'
  require_relative 'invaders_finder/scanner_setup.rb'

  PAD_CHAR = 'x' # Used to pad the sample data, to detect patterns at edges
  NEWLINE = "\n" # System-specific line separator
end
