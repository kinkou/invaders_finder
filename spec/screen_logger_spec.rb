# frozen_string_literal: true

RSpec.describe InvadersFinder::ScreenLogger do
  context 'Instance methods' do
    let(:text) { 'text' }
    let(:color) { :red }
    let(:logger) { instance_double(subject.class.to_s) }

    it '#log logs the message using default color' do
      expect(logger).to receive(:log).with(text)
      logger.log(text)
    end

    it '#log also logs the message using a specified color' do
      expect(logger).to receive(:log).with(text, color)
      logger.log(text, color)
    end
  end
end
