# frozen_string_literal: true

RSpec.describe InvadersFinder::Match do
  context 'Instance methods' do
    let(:match_object) do
      image = %w[-]
      similarity = 0.5
      offset_x = 0
      offset_y = 0
      InvadersFinder::Match.new(image, similarity, offset_x, offset_y)
    end

    specify '#log logs the match' do
      expect(match_object).to respond_to(:log)
    end
  end
end
