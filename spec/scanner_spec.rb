# frozen_string_literal: true

require 'real_data_helper.rb'
RSpec.configure { |c| c.include(RealDataHelper) }

RSpec.describe InvadersFinder::Scanner do
  context 'Instance methods' do
    let(:similarity_algorithm) { InvadersFinder::SimilarityAlgorithms::Levenshtein.new }
    let(:scanner) { InvadersFinder::Scanner.new(real_pattern, real_pattern, similarity_algorithm) }
    let(:result) { scanner.execute }

    specify '#execute returns an array of InvadersFinder::Match objects' do
      expect(result[0]).to be_instance_of(InvadersFinder::Match)
    end
  end
end
