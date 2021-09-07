# frozen_string_literal: true

RSpec.describe InvadersFinder::TextBlock do
  context 'Public methods' do
    context '#initialize' do
      let(:text_block) { InvadersFinder::TextBlock.new("-O  \n  ") }

      it 'Normalizes the input data' do
        expect(text_block.to_a).to eq(%w[-o])
      end
    end
  end
end
