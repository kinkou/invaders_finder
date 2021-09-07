# frozen_string_literal: true

RSpec.describe InvadersFinder::TextBlock do
  context 'Public methods' do
    context '#initialize' do
      let(:text_block) { InvadersFinder::TextBlock.new("-O  \n  ") }

      it 'Normalizes the input data' do
        expect(text_block.to_a).to eq(%w[-o])
      end

      it 'Assigns a :name attribute' do
        name = :block
        block = InvadersFinder::TextBlock.new('', name)
        expect(block.name).to eq(name)
      end
    end

    let(:simple_test_data) do
      <<~STR
       ab
       cd
      STR
    end

    let(:simple_text_block) { InvadersFinder::TextBlock.new(simple_test_data) }

    specify '#to_a returns an array of strings representing the text block' do
      expect(simple_text_block.to_a).to be_instance_of(Array)
      expect(simple_text_block.to_a[0]).to be_instance_of(String)
    end

    specify '#width returns the width of the text block' do
      expect(simple_text_block.width).to eq(2)
    end

    specify '#height returns the height of the text block' do
      expect(simple_text_block.height).to eq(2)
    end

    specify '#dimensions returns [width, height]' do
      expect(simple_text_block.dimensions).to eq([2, 2])
    end

    let(:padded_text_block) do
      horizontal_size = 1
      vertical_size = 1
      simple_text_block.pad(horizontal_size, vertical_size)
    end

    let(:padded_text_block_expectation) do
      %w[
        xxxx
        xabx
        xcdx
        xxxx
      ]
    end

    specify '#pad adds margins with a pad character around the text block' do
      expect(padded_text_block.to_a).to eq(padded_text_block_expectation)
    end

    specify '#unpad removes the margins' do
      expect(padded_text_block.unpad.to_a).to eq(simple_text_block.to_a)
      expect(InvadersFinder::TextBlock.new("x\nx").unpad.to_a).to eq([])
    end

    let(:subsample_expectation) { %w[d] }

    specify '#subsample_at copies a certain text area to a new instance' do
      result = simple_text_block.subsample_at(1, 1, 3, 3).to_a
      expect(result).to eq(subsample_expectation)
    end

    context '#intersect_with' do
      it 'Raises if the sample and the pattern have different dimensions' do
        error = InvadersFinder::TextBlock::InvalidDimensionsError
        expect { simple_text_block.intersect_with(padded_text_block) }.to raise_error(error)
      end

      let(:intersect_pattern_data) do
        <<~STR
          o--o
          -oo-
          oooo
          ----
        STR
      end

      let(:intersect_pattern) { InvadersFinder::TextBlock.new(intersect_pattern_data) }

      let(:intersect_sample_expectation) do
        %w[
          ab
          cd
        ]
      end

      let(:intersect_pattern_expectation) do
        %w[
          oo
          oo
        ]
      end

      it 'overlays sample and pattern and removes padded area in both, regardless of the order of parameters' do
        sample, pattern = padded_text_block.intersect_with(intersect_pattern)
        expect(sample.to_a).to eq(intersect_sample_expectation)
        expect(pattern.to_a).to eq(intersect_pattern_expectation)

        pattern, sample = intersect_pattern.intersect_with(padded_text_block)
        expect(sample.to_a).to eq(intersect_sample_expectation)
        expect(pattern.to_a).to eq(intersect_pattern_expectation)
      end
    end
  end
end
