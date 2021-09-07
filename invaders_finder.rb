# frozen_string_literal: true

# Top-level namespace for the app
module InvadersFinder
  require_relative 'invaders_finder/text_block.rb'
  require_relative 'invaders_finder/similarity_algorithms/base.rb'
  require_relative 'invaders_finder/similarity_algorithms/levenshtein.rb'
  require_relative 'invaders_finder/similarity_algorithms/white_similarity.rb'

  PAD_CHAR = 'x' # Used to pad the sample data, to detect patterns at edges
  NEWLINE = "\n" # System-specific line separator
end
