# frozen_string_literal: true

# lib/genki_yoshi/pdf_generator.rb
module GenkiYoshi
  class PDFGenerator
    def initialize(settings)
      @settings = settings
    end

    def generate
      pdf_path = @settings.output_file

      Prawn::Document.generate(pdf_path, page_size: 'A4', margin: [25, 25, 25, 25]) do |pdf|
        setup_fonts(pdf)
        grid_drawer = GridDrawer.new(pdf, @settings)

        @settings.selected_chars.each_with_index do |char_set, index|
          next if char_set.empty?

          pdf.start_new_page unless index.zero?
          grid_drawer.draw_grid_page(char_set, 15, 10, (pdf.bounds.width - 50) / 10)
        end
      end

      process_temporary_files(pdf_path)
    end

    private

    def setup_fonts(pdf)
      pdf.font_families.update('KanjiStrokeOrders' => {
                                 normal: { file: 'KanjiStrokeOrders.ttf', font: 'KanjiStrokeOrders', embed: true }
                               })
      pdf.font('KanjiStrokeOrders')
      pdf.font_size 48
    end

    def process_temporary_files(pdf_path)
      output_dir = File.dirname(pdf_path)
      image_paths = TemporaryFileManager.convert_pdf_to_images(pdf_path, output_dir)
      final_pdf = pdf_path.sub('.pdf', '_final.pdf')
      TemporaryFileManager.images_to_pdf(image_paths, final_pdf)
      TemporaryFileManager.cleanup_temporary_files(image_paths, pdf_path)
      FileUtils.mv(final_pdf, pdf_path)
    end
  end
end
