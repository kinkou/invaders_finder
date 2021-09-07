# frozen_string_literal: true

module RealDataHelper
  def real_sample_data
    File.read('data/sample_data.txt')
  end

  def real_sample
    InvadersFinder::TextBlock.new(real_sample_data)
  end

  def real_pattern_data
    YAML.load_file('data/patterns.yml')
  end

  def real_pattern
    InvadersFinder::TextBlock.new(real_pattern_data['crab'], :crab)
  end
end
