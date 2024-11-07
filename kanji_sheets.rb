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

    pdf.move_down 10

    pdf.font("KanjiStrokeOrders")
    pdf.font_size 36

    rows = 20
    cols = 12
    cell_size = (pdf.bounds.width - 50) / cols

    input_index = 0
    kanji_kana_size = input_kanji_kana.size

    (1..rows).each do |row|
      break if input_index >= kanji_kana_size

      first_char = input_kanji_kana[input_index]

      (1..cols).each do |col|
        top_left = [col * cell_size, pdf.cursor]
        pdf.stroke_rectangle(top_left, cell_size, cell_size)
        pdf.dash(1, space: 2)
        pdf.stroke_line([top_left[0] + cell_size / 2, top_left[1]], [top_left[0] + cell_size / 2, top_left[1] - cell_size])
        pdf.stroke_line([top_left[0], top_left[1] - cell_size / 2], [top_left[0] + cell_size, top_left[1] - cell_size / 2])
        pdf.undash

        if col == 1 && input_index < kanji_kana_size
          pdf.fill_color "000000"
          text_width = pdf.width_of(first_char, size: 36)
          text_x = top_left[0] + (cell_size - text_width) / 2
          text_y = top_left[1] - (cell_size * 0.80)
          pdf.draw_text first_char, at: [text_x, text_y], size: 36
        elsif col > 1
          pdf.fill_color "CCCCCC"
          text_width = pdf.width_of(first_char, size: 36)
          text_x = top_left[0] + (cell_size - text_width) / 2
          text_y = top_left[1] - (cell_size * 0.80)
          pdf.draw_text first_char, at: [text_x, text_y], size: 36
        end
      end

      pdf.move_down cell_size
      input_index += 1
    end

    while input_index < kanji_kana_size
      pdf.start_new_page
      (1..rows).each do |row|
        break if input_index >= kanji_kana_size

        first_char = input_kanji_kana[input_index]

        (1..cols).each do |col|
          top_left = [col * cell_size, pdf.cursor]
          pdf.stroke_rectangle(top_left, cell_size, cell_size)

          pdf.dash(1, space: 2)
          pdf.stroke_line([top_left[0] + cell_size / 2, top_left[1]], [top_left[0] + cell_size / 2, top_left[1] - cell_size])
          pdf.stroke_line([top_left[0], top_left[1] - cell_size / 2], [top_left[0] + cell_size, top_left[1] - cell_size / 2])
          pdf.undash

          if col == 1 && input_index < kanji_kana_size
            pdf.fill_color "000000"
            text_width = pdf.width_of(first_char, size: 36)
            text_x = top_left[0] + (cell_size - text_width) / 2
            text_y = top_left[1] - (cell_size * 0.80)
            pdf.draw_text first_char, at: [text_x, text_y], size: 36
          elsif col > 1
            pdf.fill_color "CCCCCC"
            text_width = pdf.width_of(first_char, size: 36)
            text_x = top_left[0] + (cell_size - text_width) / 2
            text_y = top_left[1] - (cell_size * 0.80)
            pdf.draw_text first_char, at: [text_x, text_y], size: 36
          end
        end

        pdf.move_down cell_size
        input_index += 1
      end
    end
  end
end

input_kanji_kana = %w[あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをんがぎぐげげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヰヱヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポ日月火水木金土曜一二三四五六七八九十百千万半数円分時週年今初始終何回台度代点番倍上下右左前後午以所中間横東西南北山川池海田野林森地島洋世界図形表大小多少高安低広太早近遠新古良悪私父母子兄弟姉妹親族男女夫妻主奥人者友民員達朝昼夕夜晩毎先次予定立歩走登止駐入出去起寝乗降忙急座泳泣家校窓門館室部屋堂院工場店社駅寺庭園行来帰発着送通進運落食飲肉茶油酒菜飯料理味切目口耳鼻顔頭首手足体力元気病生死薬医休言話申交見聞読書知忘使調計自転車船動具電品荷物紙服有名便利不同長短重強弱重軽速遅開占押引拾捨持洗作取国際特京都道府県市区町村内外会別住働売買借貸待集産建]  # Add your characters here

generate_genkoyoshi_pdf("genkoyoshi_kanji_primeira_coluna.pdf", input_kanji_kana.join(" "))
