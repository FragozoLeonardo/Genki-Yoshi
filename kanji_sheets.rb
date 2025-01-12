require 'prawn'
require 'pdf-reader'
require 'fileutils'

class GenkiYoshiCLI
  def initialize
    @grid_color = "000000"
    @character_color = "000000"
    @practice_color = "CCCCCC"
    @selected_chars = []
    @output_file = "generated_genkoyoshi.pdf"
  end

  def display_welcome_banner
    puts "\n" + "="*70
    puts "Welcome to GenkiYoshi - Japanese Manuscript Paper Generator! 原稿用紙"
    puts "="*70
    puts "\nCreate beautiful Japanese writing practice sheets customized to your needs!"
    puts "Created with ♥ for Japanese language learners"
    puts "\nTIP: For character combinations with smaller characters (like きょ, しゅ),"
    puts "     enter them together as one unit, NOT separately."
    puts "     Good: きょ, しゅ, びょ"
    puts "     Bad:  き ょ, し ゅ, び ょ\n\n"
  end

  def get_color_preference(element)
    puts "\nPlease enter the hex color code for #{element} (without #)"
    puts "You can pick colors at: https://htmlcolorcodes.com/color-picker/"
    puts "Press Enter to use default color (#{element == 'grid lines' ? 'black' : element == 'example characters' ? 'black' : 'gray'})"
    print "> "
    color = gets.chomp.upcase
    return element == 'practice characters' ? "CCCCCC" : "000000" if color.empty?
    color = "000000" unless color.match?(/^[0-9A-F]{6}$/)
    color
  end

  def input_characters(set_name)
    puts "\nEnter #{set_name} characters (or press Enter to skip)"
    puts "You can enter multiple characters with or without spaces"
    puts "Remember: Enter combinations like きょ together, not separately"
    print "> "
    chars = gets.encode("utf-8", invalid: :replace, undef: :replace, replace: "").chomp
    chars.scan(/\X/).reject { |c| c.match?(/[[:space:]]/) }
  end

  def select_characters
    puts "\nLet's input the characters you want to practice!"
    puts "You can create up to three sets of characters."
    
    set1 = input_characters("first set of")
    set2 = input_characters("second set of")
    set3 = input_characters("third set of")
    
    @selected_chars = [set1, set2, set3].reject(&:empty?)
    
    if @selected_chars.empty?
      puts "\nNo characters were entered. Please enter at least one set of characters."
      select_characters
    end
  end

  def get_output_filename
    puts "\nEnter the output filename (default: generated_genkoyoshi.pdf)"
    print "> "
    filename = gets.chomp
    @output_file = filename unless filename.empty?
    @output_file = @output_file + ".pdf" unless @output_file.end_with?(".pdf")
  end

  def confirm_settings
    puts "\nCurrent Settings:"
    puts "================="
    puts "Grid Color: ##{@grid_color}"
    puts "Example Character Color: ##{@character_color}"
    puts "Practice Character Color: ##{@practice_color}"
    puts "Output File: #{@output_file}"
    puts "Character Sets:"
    @selected_chars.each_with_index do |set, index|
      puts "  Set #{index + 1}: #{set.join(' ')}"
    end
    
    print "\nProceed with these settings? (Y/n): "
    response = gets.chomp.downcase
    response == 'y' || response.empty?
  end

  def display_progress(step)
    progress = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏']
    progress.each do |char|
      print "\r#{char} #{step}..."
      sleep 0.1
    end
  end

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

  def cleanup_temporary_files(image_paths, original_pdf)
    image_paths.each { |path| File.delete(path) if File.exist?(path) }
    File.delete(original_pdf) if File.exist?(original_pdf)
  end

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

  def draw_grid_cell(pdf, top_left, cell_size)
    pdf.stroke_color = @grid_color
    pdf.stroke_rectangle(top_left, cell_size, cell_size)
    pdf.dash(1, space: 2)
    pdf.stroke_line(
      [top_left[0] + cell_size / 2, top_left[1]],
      [top_left[0] + cell_size / 2, top_left[1] - cell_size]
    )
    pdf.stroke_line(
      [top_left[0], top_left[1] - cell_size / 2],
      [top_left[0] + cell_size, top_left[1] - cell_size / 2]
    )
    pdf.undash
  end

  def draw_grid_page(pdf, characters, rows, cols, cell_size)
    input_index = 0
    while input_index < characters.length
      (1..rows).each do |row|
        break if input_index >= characters.length
        current_char = characters[input_index]
        is_youon_start = current_char.match?(/[きぎしじちぢにひびぴみりキギシジチヂニヒビピミリ]/)
        next_char = input_index + 1 < characters.length ? characters[input_index + 1] : nil
        is_youon_pair = next_char&.match?(/[ゃゅょャュョ]/)

        (1..cols).each do |col|
          top_left = [col * cell_size, pdf.cursor]
          draw_grid_cell(pdf, top_left, cell_size)

          if is_youon_start && is_youon_pair
            case col
            when 1
              draw_char(pdf, current_char, top_left, cell_size, @character_color)
            when 2
              draw_char(pdf, next_char, top_left, cell_size, @character_color, true)
            else
              if col % 2 == 1
                draw_char(pdf, current_char, top_left, cell_size, @practice_color)
              else
                draw_char(pdf, next_char, top_left, cell_size, @practice_color, true)
              end
            end
          else
            color = col == 1 ? @character_color : @practice_color
            draw_char(pdf, current_char, top_left, cell_size, color) if input_index < characters.length
          end
        end

        pdf.move_down cell_size
        input_index += 1
        if is_youon_start && is_youon_pair
          input_index += 1
        end
      end

      if input_index < characters.length
        pdf.start_new_page
      end
    end
  end

  def generate_genkoyoshi_pdf
    display_progress("Creating PDF")
    
    pdf_path = @output_file
    
    Prawn::Document.generate(pdf_path, page_size: 'A4', margin: [25, 25, 25, 25]) do |pdf|
      pdf.font_families.update("KanjiStrokeOrders" => {
        normal: { file: "KanjiStrokeOrders.ttf", font: "KanjiStrokeOrders", embed: true }
      })    

      pdf.font("KanjiStrokeOrders")
      pdf.font_size 48

      @selected_chars.each_with_index do |char_set, index|
        next if char_set.empty?
        pdf.start_new_page unless index == 0
        draw_grid_page(pdf, char_set, 15, 10, (pdf.bounds.width - 50) / 10)
      end
    end

    display_progress("Converting to final format")
    
    output_dir = File.dirname(pdf_path)
    image_paths = convert_pdf_to_images(pdf_path, output_dir)
    final_pdf = pdf_path.sub('.pdf', '_final.pdf')
    images_to_pdf(image_paths, final_pdf)
    cleanup_temporary_files(image_paths, pdf_path)
    
    FileUtils.mv(final_pdf, pdf_path)
  end

  def run
    display_welcome_banner
    @grid_color = get_color_preference('grid lines')
    @character_color = get_color_preference('example characters')
    @practice_color = get_color_preference('practice characters')
    select_characters
    get_output_filename
    return unless confirm_settings

    puts "\nGenerating your custom GenkiYoshi paper..."
    generate_genkoyoshi_pdf

    puts "\n✨ Success! Your custom GenkiYoshi paper has been generated!"
    puts "📄 File saved as: #{@output_file}"
    puts "\nThank you for using GenkiYoshi! がんばって！\n\n"
  end
end

STDIN.set_encoding(Encoding::UTF_8)
GenkiYoshiCLI.new.run