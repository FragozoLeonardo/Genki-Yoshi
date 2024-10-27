require 'prawn'

def generate_genkoyoshi_pdf(file_name)
  Prawn::Document.generate(file_name, page_size: 'A4') do |pdf|
    pdf.font_families.update("NotoSansJP-Light" => {
      normal: "NotoSansJP-Light.ttf"
    })

    pdf.font("NotoSansJP-Light")
    pdf.font_size 12
    pdf.text "名: レオナルド", align: :left
    pdf.move_down 10

    rows = 16
    cols = 10
    cell_size = (pdf.bounds.width - 50) / cols

    # Defina a cor azul suave
    pdf.fill_color "ADD8E6"  # Um azul claro
    pdf.stroke_color "ADD8E6"  # Usar a mesma cor para as linhas

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

    # Volte para a cor padrão para textos e outros desenhos
    pdf.fill_color "000000"  # Preto
    pdf.stroke_color "000000"  # Preto
  end
end

# Chamada da função para gerar o PDF com o grid em azul suave
generate_genkoyoshi_pdf("genkoyoshi_grid.pdf")
