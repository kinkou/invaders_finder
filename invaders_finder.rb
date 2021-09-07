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
  require_relative 'invaders_finder/match.rb'
  require_relative 'invaders_finder/scanner.rb'
  require_relative 'invaders_finder/screen_logger.rb'

  PAD_CHAR = 'x' # Used to pad the sample data, to detect patterns at edges
  NEWLINE = "\n" # System-specific line separator

  SIMILARITY_ALGORITHMS = { # Used to detect similarity between a sample and a pattern
    levenshtein: SimilarityAlgorithms::Levenshtein,
    white_similarity: SimilarityAlgorithms::WhiteSimilarity
  }.freeze
  USE_ALGORITHM = :levenshtein

  SAMPLE_DATA_FILE = 'data/sample_data.txt' # Radar sample data
  PATTERNS_DATA_FILE = 'data/patterns.yml' # Space invader patterns

  LOGGER = ScreenLogger.new # Where to output

  # Entry point class
  class Main
    def self.execute # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      sample = TextBlock.new(File.read(SAMPLE_DATA_FILE), :radar_sample)
      pattern_data = YAML.load_file(PATTERNS_DATA_FILE)
      invaders_names = pattern_data.keys

      invaders_names.each do |name|
        pattern = TextBlock.new(pattern_data[name], name.to_sym)
        LOGGER.log("Finding #{pattern.name.capitalize}...", :bright)

        similarity_algorithm = SIMILARITY_ALGORITHMS[USE_ALGORITHM].new
        matches = Scanner.new(sample, pattern, similarity_algorithm).execute

        LOGGER.log("Found #{matches.size} matches.", matches.size.zero? ? :red : :green)
        matches.each(&:log)
      end
    end
  end
end
