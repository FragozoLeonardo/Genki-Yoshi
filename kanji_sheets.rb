require 'prawn'
require 'pdf-reader'

def convert_pdf_to_images(pdf_path, output_dir)
  FileUtils.mkdir_p(output_dir)
  base_name = File.basename(pdf_path, '.pdf')
  output_pattern = File.join(output_dir, "#{base_name}-%d.png")
  
  system("pdftocairo -png -r 300 #{pdf_path} #{File.join(output_dir, base_name)}")
  
  Dir[File.join(output_dir, "#{base_name}-*.png")]
end

def images_to_pdf(image_paths, output_pdf)
  Prawn::Document.generate(output_pdf, page_size: 'A4', margin: 0) do |pdf|
    image_paths.sort.each_with_index do |image_path, index|
      pdf.start_new_page if index > 0
      pdf.image image_path, at: [0, pdf.bounds.height], width: pdf.bounds.width
    end
  end
  output_pdf
end

def generate_genkoyoshi_pdf(file_name, input_kanji_kana, convert_to_image: true)
  pdf_path = file_name
  
  Prawn::Document.generate(pdf_path, page_size: 'A4', margin: [25, 25, 25, 25]) do |pdf|
    pdf.font_families.update("KanjiStrokeOrders" => {
      normal: { file: "KanjiStrokeOrders.ttf", font: "KanjiStrokeOrders", embed: true }
    })
    
    pdf.font_families.update("NotoSansJP-Light" => {
      normal: { file: "NotoSansJP-Light.ttf", font: "NotoSansJP-Light", embed: true }
    })    

    pdf.font("NotoSansJP-Light")
    pdf.font_size 11
    pdf.move_down 10
    pdf.font("KanjiStrokeOrders")
    pdf.font_size 48

    rows = 15
    cols = 10
    cell_size = (pdf.bounds.width - 50) / cols
    input_index = 0
    kanji_kana_size = input_kanji_kana.length

    def draw_char(pdf, char, top_left, cell_size, color, is_small = false)
      pdf.fill_color color
      size = is_small ? 24 : 48
      text_width = pdf.width_of(char, size: size)
      if is_small
        subgrid_center_x = top_left[0] + (cell_size / 4)
        text_x = subgrid_center_x - (text_width / 2)
        text_y = top_left[1] - (cell_size * 0.85)
      else
        text_x = top_left[0] + (cell_size - text_width) / 2
        text_y = top_left[1] - (cell_size * 0.80)
      end
      pdf.draw_text char, at: [text_x, text_y], size: size
    end

    while input_index < kanji_kana_size
      (1..rows).each do |row|
        break if input_index >= kanji_kana_size
        current_char = input_kanji_kana[input_index]
        is_youon_start = current_char.match?(/[きぎしじちぢにひびぴみりキギシジチヂニヒビピミリ]/)
        next_char = input_index + 1 < kanji_kana_size ? input_kanji_kana[input_index + 1] : nil
        is_youon_pair = next_char&.match?(/[ゃゅょャュョ]/)

        (1..cols).each do |col|
          top_left = [col * cell_size, pdf.cursor]
          pdf.stroke_rectangle(top_left, cell_size, cell_size)
          pdf.dash(1, space: 2)
          pdf.stroke_line([top_left[0] + cell_size / 2, top_left[1]], [top_left[0] + cell_size / 2, top_left[1] - cell_size])
          pdf.stroke_line([top_left[0], top_left[1] - cell_size / 2], [top_left[0] + cell_size, top_left[1] - cell_size / 2])
          pdf.undash

          if is_youon_start && is_youon_pair
            case col
            when 1
              draw_char(pdf, current_char, top_left, cell_size, "000000")
            when 2
              draw_char(pdf, next_char, top_left, cell_size, "000000", true)
            else
              if col % 2 == 1
                draw_char(pdf, current_char, top_left, cell_size, "CCCCCC")
              else
                draw_char(pdf, next_char, top_left, cell_size, "CCCCCC", true)
              end
            end
          else
            start_col = col == 1 ? "000000" : "CCCCCC"
            draw_char(pdf, current_char, top_left, cell_size, start_col) if input_index < kanji_kana_size
          end
        end

        pdf.move_down cell_size
        input_index += 1
        if is_youon_start && is_youon_pair
          input_index += 1
        end
      end

      if input_index < kanji_kana_size
        pdf.start_new_page
      end
    end
  end

  if convert_to_image
    output_dir = File.dirname(pdf_path)
    image_paths = convert_pdf_to_images(pdf_path, output_dir)
    final_pdf = pdf_path.sub('.pdf', '_final.pdf')
    images_to_pdf(image_paths, final_pdf)
    return final_pdf
  end
  
  return pdf_path
end

youon_hiragana = [["き", "ゃ"], ["き", "ゅ"], ["き", "ょ"], ["ぎ", "ゃ"], ["ぎ", "ゅ"], ["ぎ", "ょ"],  ["し", "ゃ"], ["し", "ゅ"], ["し", "ょ"], ["じ", "ゃ"], ["じ", "ゅ"], ["じ", "ょ"], ["ち", "ゃ"], ["ち", "ゅ"], ["ち", "ょ"], ["ぢ", "ゃ"], ["ぢ", "ゅ"], ["ぢ", "ょ"], ["に", "ゃ"], ["に", "ゅ"], ["に", "ょ"], ["ひ", "ゃ"], ["ひ", "ゅ"], ["ひ", "ょ"],  ["び", "ゃ"], ["び", "ゅ"], ["び", "ょ"], ["ぴ", "ゃ"], ["ぴ", "ゅ"], ["ぴ", "ょ"],  ["み", "ゃ"], ["み", "ゅ"], ["み", "ょ"], ["り", "ゃ"], ["り", "ゅ"], ["り", "ょ"]].flatten

youon_katakana = [["キ", "ャ"], ["キ", "ュ"], ["キ", "ョ"], ["ギ", "ャ"], ["ギ", "ュ"], ["ギ", "ョ"], ["シ", "ャ"], ["シ", "ュ"], ["シ", "ョ"], ["ジ", "ャ"], ["ジ", "ュ"], ["ジ", "ョ"], ["チ", "ャ"], ["チ", "ュ"], ["チ", "ョ"], ["ヂ", "ャ"], ["ヂ", "ュ"], ["ヂ", "ョ"],  ["ニ", "ャ"], ["ニ", "ュ"], ["ニ", "ョ"], ["ヒ", "ャ"], ["ヒ", "ュ"], ["ヒ", "ョ"],  ["ビ", "ャ"], ["ビ", "ュ"], ["ビ", "ョ"], ["ピ", "ャ"], ["ピ", "ュ"], ["ピ", "ョ"], ["ミ", "ャ"], ["ミ", "ュ"], ["ミ", "ョ"], ["リ", "ャ"], ["リ", "ュ"], ["リ", "ョ"]].flatten

basic_kana = %w[あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモ  ヤユヨラリルレロワヰヱヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポ]

kanji = %w[日月火水木金土曜一二三四五六七八九十百千万半数円分時週年今初始終何回台度代点番倍上下右左前後午以所中間横東西南北山川池海田野林森地島洋世界図形表大小多少高安低広太早近遠新古良悪私父母子兄弟姉妹親族男女夫妻主奥人者友民員達朝昼夕夜晩毎先次予定立歩走登止駐入出去起寝乗降忙急座泳泣家校窓門館室部屋堂院工場店社駅寺庭園行来帰発着送通進運落食飲肉茶油酒菜飯料理味切目口耳鼻顔頭首手足体力元気病生死薬医休言話申交見聞読書知忘使調計自転車船動具電品荷物紙服有名便利不同長短強弱重軽速遅開閉押引拾捨持洗作取国際特京都道府県市区町村内外合別住働売買借貸待集産建合遊禁失正神祭化本映画旅写真歌絵心好苦楽]

input_kanji_kana = (basic_kana + youon_hiragana + youon_katakana + kanji).map(&:chars).flatten

generate_genkoyoshi_pdf("genkoyoshi_Leo.pdf", input_kanji_kana, convert_to_image: true)
