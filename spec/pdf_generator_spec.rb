# frozen_string_literal: true

# spec/pdf_generator_spec.rb
require 'spec_helper'

RSpec.describe GenkiYoshi::PDFGenerator do
  let(:settings) { GenkiYoshi::Settings.new }
  let(:pdf_generator) { described_class.new(settings) }

  before do
    allow(Prawn::Document).to receive(:generate).and_yield(double('pdf').as_null_object)
    allow_any_instance_of(GenkiYoshi::GridDrawer).to receive(:draw_grid_page)

    allow(GenkiYoshi::TemporaryFileManager).to receive(:convert_pdf_to_images).and_return(['image1.png', 'image2.png'])
    allow(GenkiYoshi::TemporaryFileManager).to receive(:images_to_pdf).and_return('test_output.pdf')
    allow(GenkiYoshi::TemporaryFileManager).to receive(:cleanup_temporary_files)
    allow(FileUtils).to receive(:mv)
  end

  describe '#generate' do
    it 'does not raise errors' do
      settings.output_file = 'test_output.pdf'
      settings.selected_chars = [%w[あ い う]]

      expect { pdf_generator.generate }.not_to raise_error
    end

    it 'handles empty character sets gracefully' do
      settings.output_file = 'test_empty.pdf'
      settings.selected_chars = [[]]

      expect { pdf_generator.generate }.not_to raise_error
    end
  end
end
