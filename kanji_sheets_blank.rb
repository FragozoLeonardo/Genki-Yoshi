require 'prawn'

def generate_genkoyoshi_pdf(file_name)
  Prawn::Document.generate(file_name, page_size: 'A4') do |pdf|
    pdf.font_families.update("NotoSansJP-Light" => {
      normal: "NotoSansJP-Light.ttf"
    })

    pdf.font("NotoSansJP-Light")
    pdf.font_size 11

    pdf.move_down 10

    rows = 20
    cols = 12
    cell_size = (pdf.bounds.width - 50) / cols

    (1..rows).each do |row|
      (1..cols).each do |col|
        top_left = [col * cell_size, pdf.cursor]
        pdf.stroke_rectangle(top_left, cell_size, cell_size)

        pdf.dash(1, space: 2)
        pdf.stroke_line([top_left[0] + cell_size / 2, top_left[1]], [top_left[0] + cell_size / 2, top_left[1] - cell_size])
        pdf.stroke_line([top_left[0], top_left[1] - cell_size / 2], [top_left[0] + cell_size, top_left[1] - cell_size / 2])
        pdf.undash
      end

      pdf.move_down cell_size
    end
  end
end

generate_genkoyoshi_pdf("genkoyoshi_grid.pdf")
