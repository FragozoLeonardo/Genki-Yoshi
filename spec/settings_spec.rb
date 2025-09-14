# frozen_string_literal: true

# spec/settings_spec.rb
require 'spec_helper'

RSpec.describe GenkiYoshi::Settings do
  describe '#initialize' do
    it 'sets default values' do
      settings = described_class.new
      expect(settings.grid_color).to eq('000000')
      expect(settings.character_color).to eq('000000')
      expect(settings.practice_color).to eq('CCCCCC')
      expect(settings.selected_chars).to eq([])
      expect(settings.output_file).to eq('generated_genkoyoshi.pdf')
    end
  end
end
