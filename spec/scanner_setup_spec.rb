# frozen_string_literal: true

require 'real_data_helper.rb'
RSpec.configure { |c| c.include(RealDataHelper) }

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

  context 'Instance methods' do
    let(:scanner_setup) { InvadersFinder::ScannerSetup.new(real_sample, real_pattern) }

    specify '#frame_width returns the scanning frame width' do
      expect(scanner_setup.frame_width).to eq(11)
    end

    specify '#frame_height returns the scanning frame height' do
      expect(scanner_setup.frame_height).to eq(8)
    end

    specify '#horizontal_pad_size calculates how much to pad the sample horizontally' do
      expect(scanner_setup.horizontal_pad_size).to eq(6)
    end

    specify '#vertical_pad_size calculates how much to pad the sample vertically' do
      expect(scanner_setup.vertical_pad_size).to eq(4)
    end

    specify '#steps_right calculates how many moves to the right the scanning frame will make' do
      expect(scanner_setup.steps_right).to eq(102)
    end

    specify '#steps_down calculates how many moves downwards the scanning frame will make' do
      expect(scanner_setup.steps_down).to eq(51)
    end

    specify '#unpad_offset_x calculates the 1-based horizontal offset disregarding the padding' do
      expect(scanner_setup.unpad_offset_x(50)).to eq(45)
    end

    specify '#unpad_offset_y calculates the 1-based horizontal offset disregarding the padding' do
      expect(scanner_setup.unpad_offset_y(20)).to eq(17)
    end
  end
end
