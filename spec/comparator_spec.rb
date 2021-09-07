# frozen_string_literal: true

require 'real_data_helper.rb'
RSpec.configure { |c| c.include(RealDataHelper) }

RSpec.describe InvadersFinder::Comparator do
  context 'Public methods' do
    let(:subsample) do
      offset_x = 60
      offset_y = 13
      width = real_pattern.width
      height = real_pattern.height
      real_sample.subsample_at(offset_x, offset_y, width, height)
    end

    let(:white_similarity_algorithm) { InvadersFinder::SimilarityAlgorithms::WhiteSimilarity.new }

    let(:levenshtein_algorithm) { InvadersFinder::SimilarityAlgorithms::Levenshtein.new }

    specify '#new raises if the sample and the pattern have different dimensions' do
      text_block_a = InvadersFinder::TextBlock.new('-')
      text_block_b = InvadersFinder::TextBlock.new('--')
      comparator = InvadersFinder::Comparator
      error = InvadersFinder::Comparator::InvalidDimensionsError
      expect { comparator.new(text_block_a, text_block_b, levenshtein_algorithm) }.to raise_error(error)
    end

    context 'Using Levenshtein algorithm' do
      specify '#execute detects 100% similarity between two identical text blocks' do
        comparator = InvadersFinder::Comparator.new(real_pattern, real_pattern, levenshtein_algorithm)
        expect(comparator.execute).to eq(1.0)
      end

      specify '#execute detects 85% similarity between a radar sample and a pattern' do
        comparator = InvadersFinder::Comparator.new(subsample, real_pattern, levenshtein_algorithm)
        expect(comparator.execute).to eq(0.854)
      end
    end
  end
end
