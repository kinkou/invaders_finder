# frozen_string_literal: true

RSpec.describe InvadersFinder::TextBlock do
  context 'Public methods' do
    context '#initialize' do
      let(:text_block) { InvadersFinder::TextBlock.new("-O  \n  ") }

      it 'Normalizes the input data' do
        expect(text_block.to_a).to eq(%w[-o])
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
  end
end
