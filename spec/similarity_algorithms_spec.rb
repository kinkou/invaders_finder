# frozen_string_literal: true

RSpec.describe 'Similarity algorithms' do
  describe InvadersFinder::SimilarityAlgorithms::Base do
    specify '#to_percent converts similarity to percent' do
      expect(subject.to_percent(0.5)).to eq(50.0)
    end
  end

  context 'Subclasses' do
    let(:pattern) { '-o-o---' }
    let(:sample_a) { '-o-o---' }
    let(:sample_b) { '-oo--o-' }

    describe InvadersFinder::SimilarityAlgorithms::Levenshtein do
      specify '#compare calculates similarity between two strings in the range of [0.0, 1.0]' do
        expect(subject.compare(pattern, sample_a)).to eq(1)
        expect(subject.compare(pattern, sample_b)).to eq(0.5)
      end

      specify '#threshold returns an algorithm-specific match threshold' do
        expect(subject.threshold).to eq(0.65)
      end
    end

    describe InvadersFinder::SimilarityAlgorithms::WhiteSimilarity do
      specify '#compare calculates similarity between two strings in the range of [0.0, 1.0]' do
        expect(subject.compare(pattern, sample_a)).to eq(1)
        expect(subject.compare(pattern, sample_b)).to eq(0.833)
      end

      specify '#threshold returns an algorithm-specific match threshold' do
        expect(subject.threshold).to eq(0.82)
      end
    end
  end
end
