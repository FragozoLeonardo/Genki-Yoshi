require 'prawn'

def generate_genkoyoshi_pdf(file_name, input_kanji_kana)
  Prawn::Document.generate(file_name, page_size: 'A4') do |pdf|
    pdf.font_families.update("KanjiStrokeOrders" => {
      normal: "KanjiStrokeOrders.ttf"
    })
    pdf.font_families.update("NotoSansJP-Light" => {
      normal: "NotoSansJP-Light.ttf"
    })

    pdf.font("NotoSansJP-Light")
    pdf.font_size 11
    pdf.text "名: レオナルド", align: :left
    pdf.move_down 10

    pdf.font("KanjiStrokeOrders")
    pdf.font_size 42

    rows = 16
    cols = 10
    cell_size = (pdf.bounds.width - 50) / cols

    input_index = 0
    kanji_kana_size = input_kanji_kana.size

    (1..rows).each do |row|
      break if input_index >= kanji_kana_size

      (1..cols).each do |col|
        top_left = [col * cell_size, pdf.cursor]
        pdf.stroke_rectangle(top_left, cell_size, cell_size)

        pdf.dash(1, space: 2)
        pdf.stroke_line([top_left[0] + cell_size / 2, top_left[1]], [top_left[0] + cell_size / 2, top_left[1] - cell_size])
        pdf.stroke_line([top_left[0], top_left[1] - cell_size / 2], [top_left[0] + cell_size, top_left[1] - cell_size / 2])
        pdf.undash

        if col == 1 && input_index < kanji_kana_size
          pdf.fill_color "CCCCCC"
          text_width = pdf.width_of(input_kanji_kana[input_index], size: 42)
          text_x = top_left[0] + (cell_size - text_width) / 2
          text_y = top_left[1] - (cell_size * 0.80)

          pdf.draw_text input_kanji_kana[input_index], at: [text_x, text_y], size: 42
          pdf.fill_color "000000"
          input_index += 1
        end
      end

      pdf.move_down cell_size
    end

    while input_index < kanji_kana_size
      pdf.start_new_page
      (1..rows).each do |row|
        break if input_index >= kanji_kana_size

        (1..cols).each do |col|
          top_left = [col * cell_size, pdf.cursor]
          pdf.stroke_rectangle(top_left, cell_size, cell_size)

          pdf.dash(1, space: 2)
          pdf.stroke_line([top_left[0] + cell_size / 2, top_left[1]], [top_left[0] + cell_size / 2, top_left[1] - cell_size])
          pdf.stroke_line([top_left[0], top_left[1] - cell_size / 2], [top_left[0] + cell_size, top_left[1] - cell_size / 2])
          pdf.undash

          if col == 1 && input_index < kanji_kana_size
            pdf.fill_color "CCCCCC"
            text_width = pdf.width_of(input_kanji_kana[input_index], size: 42)
            text_x = top_left[0] + (cell_size - text_width) / 2
            text_y = top_left[1] - (cell_size * 0.80)

            pdf.draw_text input_kanji_kana[input_index], at: [text_x, text_y], size: 42
            pdf.fill_color "000000"
            input_index += 1
          end
        end

        pdf.move_down cell_size
      end
    end
  end
end

input_kanji_kana = %w[あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをんがぎぐげげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヰヱヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポ]  # Adicione os caracteres aqui

generate_genkoyoshi_pdf("genkoyoshi_kanji_primeira_coluna.pdf", input_kanji_kana.join(" "))
