# frozen_string_literal: true

# lib/genki_yoshi/temporary_file_manager.rb
require 'fileutils'
require 'shellwords'

module GenkiYoshi
  class TemporaryFileManager
    def self.convert_pdf_to_images(pdf_path, output_dir)
      FileUtils.mkdir_p(output_dir)
      base_name = File.basename(pdf_path, '.pdf')

      success = system("pdftocairo -png -r 300 #{Shellwords.shellescape(pdf_path)} #{Shellwords.shellescape(File.join(
                                                                                                              output_dir, base_name
                                                                                                            ))}")

      raise 'Failed to convert PDF to images. Please make sure pdftocairo is installed.' unless success

      Dir[File.join(output_dir, "#{base_name}-*.png")].sort
    end

    def self.images_to_pdf(image_paths, output_pdf)
      Prawn::Document.generate(output_pdf, page_size: 'A4', margin: 0) do |pdf|
        image_paths.each_with_index do |image_path, index|
          pdf.start_new_page if index.positive?
          pdf.image image_path, at: [0, pdf.bounds.height], width: pdf.bounds.width
        end
      end
      output_pdf
    end

    def self.cleanup_temporary_files(image_paths, original_pdf)
      image_paths.each { |path| File.delete(path) if File.exist?(path) }
      File.delete(original_pdf) if File.exist?(original_pdf)
    end
  end
end
