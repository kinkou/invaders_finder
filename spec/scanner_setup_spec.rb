# frozen_string_literal: true

RSpec.describe InvadersFinder::ScannerSetup do
  context 'InvadersFinder::ScannerSetup::InvalidDimensionsError exception' do
    let(:exception) { InvadersFinder::ScannerSetup::InvalidDimensionsError }

    it 'Is raised if the sample is narrower than the pattern' do
      sample = InvadersFinder::TextBlock.new('-')
      pattern = InvadersFinder::TextBlock.new('oo', :crab)
  
      expect { InvadersFinder::ScannerSetup.new(sample, pattern) }.to raise_exception(exception)
    end

    it 'Is raised if the sample is shorter than the pattern' do
      sample = InvadersFinder::TextBlock.new('-')
      pattern = InvadersFinder::TextBlock.new("-\n-", :crab)
  
      expect { InvadersFinder::ScannerSetup.new(sample, pattern) }.to raise_exception(exception)
    end
  end
end
