require 'prawn'

class BlankGenkoyoshi
  def initialize
    @grid_color = "000000"
    @margin = 25
    @rows = 20
    @cols = 12
    @output_file = "genkoyoshi_grid.pdf"
  end

  def display_menu
    puts "\n#{"-"*50}"
    puts "Blank Genkoyoshi Generator 原稿用紙"
    puts "-"*50
    puts "\nCustomize your writing grid:"
  end

  def get_grid_settings
    puts "\nNumber of rows (default: 20, max: 30)"
    print "> "
    rows = gets.chomp
    @rows = rows.to_i if rows.match?(/^\d+$/) && rows.to_i.between?(1, 30)

    puts "\nNumber of columns (default: 12, max: 20)"
    print "> "
    cols = gets.chomp
    @cols = cols.to_i if cols.match?(/^\d+$/) && cols.to_i.between?(1, 20)

    puts "\nGrid color hex code (default: 000000/black)"
    puts "Pick colors at: https://htmlcolorcodes.com/color-picker/"
    print "> "
    color = gets.chomp.upcase
    @grid_color = color if color.match?(/^[0-9A-F]{6}$/)

    puts "\nPage margin in points (default: 25, min: 0, max: 100)"
    print "> "
    margin = gets.chomp
    @margin = margin.to_i if margin.match?(/^\d+$/) && margin.to_i.between?(0, 100)

    puts "\nOutput filename (default: genkoyoshi_grid.pdf)"
    print "> "
    filename = gets.chomp
    @output_file = filename unless filename.empty?
    @output_file = @output_file + ".pdf" unless @output_file.end_with?(".pdf")
  end

  def confirm_settings
    puts "\nCurrent Settings:"
    puts "================"
    puts "Rows: #{@rows}"
    puts "Columns: #{@cols}"
    puts "Grid Color: ##{@grid_color}"
    puts "Margin: #{@margin}pt"
    puts "Output File: #{@output_file}"
    
    print "\nGenerate grid with these settings? (Y/n): "
    response = gets.chomp.downcase
    response == 'y' || response.empty?
  end

  def generate_pdf
    Prawn::Document.generate(@output_file, page_size: 'A4', margin: @margin) do |pdf|
      pdf.font_families.update("KanjiStrokeOrders" => {
        normal: { file: "KanjiStrokeOrders.ttf", font: "KanjiStrokeOrders" }
      })

      pdf.font("KanjiStrokeOrders")
      pdf.font_size 11

      cell_size = (pdf.bounds.width) / @cols

      (1..@rows).each do |row|
        (1..@cols).each do |col|
          top_left = [col * cell_size - cell_size, pdf.cursor]
          
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
        pdf.move_down cell_size
      end
    end
  end

  def run
    display_menu
    get_grid_settings
    return unless confirm_settings

    puts "\nGenerating your custom grid..."
    generate_pdf
    puts "\n✨ Success! Grid saved as: #{@output_file}\n\n"
  end
end

BlankGenkoyoshi.new.run