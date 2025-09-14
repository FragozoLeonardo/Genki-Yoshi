# frozen_string_literal: true

# spec/temporary_file_manager_spec.rb
require 'spec_helper'
require 'shellwords'

RSpec.describe GenkiYoshi::TemporaryFileManager do
  describe '.convert_pdf_to_images' do
    it 'creates output directory and calls pdftocairo' do
      pdf_path = 'test.pdf'
      output_dir = 'test_output'
      expected_command = "pdftocairo -png -r 300 #{Shellwords.shellescape(pdf_path)} #{Shellwords.shellescape(File.join(
                                                                                                                output_dir, 'test'
                                                                                                              ))}"

      expect(FileUtils).to receive(:mkdir_p).with(output_dir)
      expect(described_class).to receive(:system).with(expected_command).and_return(true)
      expect(Dir).to receive(:[]).with('test_output/test-*.png').and_return(['test_output/test-1.png'])

      result = described_class.convert_pdf_to_images(pdf_path, output_dir)
      expect(result).to eq(['test_output/test-1.png'])
    end

    it 'raises an error if pdftocairo fails' do
      pdf_path = 'test.pdf'
      output_dir = 'test_output'

      expect(FileUtils).to receive(:mkdir_p).with(output_dir)
      expect(described_class).to receive(:system).with('pdftocairo -png -r 300 test.pdf test_output/test').and_return(false)

      expect do
        described_class.convert_pdf_to_images(pdf_path, output_dir)
      end.to raise_error(RuntimeError, 'Failed to convert PDF to images. Please make sure pdftocairo is installed.')
    end
  end

  describe '.images_to_pdf' do
    it 'creates a PDF from images' do
      image_paths = ['image1.png', 'image2.png']
      output_pdf = 'output.pdf'

      prawn_doc = double('Prawn::Document')
      bounds_double = double(height: 800, width: 600)
      allow(prawn_doc).to receive(:bounds).and_return(bounds_double)

      expect(Prawn::Document).to receive(:generate).with(output_pdf, page_size: 'A4', margin: 0).and_yield(prawn_doc)

      expect(prawn_doc).to receive(:start_new_page).once
      expect(prawn_doc).to receive(:image).with('image1.png', at: [0, 800], width: 600)
      expect(prawn_doc).to receive(:image).with('image2.png', at: [0, 800], width: 600)

      result = described_class.images_to_pdf(image_paths, output_pdf)
      expect(result).to eq(output_pdf)
    end
  end

  describe '.cleanup_temporary_files' do
    it 'deletes existing files' do
      image_paths = ['image1.png', 'image2.png']
      original_pdf = 'original.pdf'

      allow(File).to receive(:exist?).with('image1.png').and_return(true)
      allow(File).to receive(:exist?).with('image2.png').and_return(true)
      allow(File).to receive(:exist?).with('original.pdf').and_return(true)

      expect(File).to receive(:delete).with('image1.png')
      expect(File).to receive(:delete).with('image2.png')
      expect(File).to receive(:delete).with('original.pdf')

      described_class.cleanup_temporary_files(image_paths, original_pdf)
    end

    it 'does not attempt to delete non-existent files' do
      image_paths = ['image1.png', 'image2.png']
      original_pdf = 'original.pdf'

      allow(File).to receive(:exist?).with('image1.png').and_return(false)
      allow(File).to receive(:exist?).with('image2.png').and_return(false)
      allow(File).to receive(:exist?).with('original.pdf').and_return(false)

      expect(File).not_to receive(:delete).with('image1.png')
      expect(File).not_to receive(:delete).with('image2.png')
      expect(File).not_to receive(:delete).with('original.pdf')

      described_class.cleanup_temporary_files(image_paths, original_pdf)
    end
  end
end
