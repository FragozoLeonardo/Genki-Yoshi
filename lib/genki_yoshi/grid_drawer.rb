# frozen_string_literal: true

# lib/genki_yoshi/grid_drawer.rb
module GenkiYoshi
  class GridDrawer
    def initialize(pdf, settings)
      @pdf = pdf
      @settings = settings
    end

    def draw_char(char, top_left, cell_size, color, is_small = false)
      @pdf.fill_color color
      size = is_small ? 24 : 48
      text_width = @pdf.width_of(char, size: size)

      if is_small
        subgrid_center_x = top_left[0] + (cell_size / 4)
        text_x = subgrid_center_x - (text_width / 2)
        text_y = top_left[1] - (cell_size * 0.85)
      else
        text_x = top_left[0] + (cell_size - text_width) / 2
        text_y = top_left[1] - (cell_size * 0.80)
      end

      @pdf.draw_text char, at: [text_x, text_y], size: size
    end

    def draw_grid_cell(top_left, cell_size)
      @pdf.stroke_color = @settings.grid_color
      @pdf.stroke_rectangle(top_left, cell_size, cell_size)
      @pdf.dash(1, space: 2)

      @pdf.stroke_line(
        [top_left[0] + cell_size / 2, top_left[1]],
        [top_left[0] + cell_size / 2, top_left[1] - cell_size]
      )

      @pdf.stroke_line(
        [top_left[0], top_left[1] - cell_size / 2],
        [top_left[0] + cell_size, top_left[1] - cell_size / 2]
      )

      @pdf.undash
    end

    def draw_grid_page(characters, rows, cols, cell_size)
      input_index = 0

      while input_index < characters.length
        (1..rows).each do |_row|
          break if input_index >= characters.length

          current_char = characters[input_index]
          is_youon_start = CharacterProcessor.youon_start?(current_char)
          next_char = input_index + 1 < characters.length ? characters[input_index + 1] : nil
          is_youon_pair = CharacterProcessor.youon_pair?(next_char)

          (1..cols).each do |col|
            top_left = [col * cell_size, @pdf.cursor]
            draw_grid_cell(top_left, cell_size)

            if is_youon_start && is_youon_pair
              case col
              when 1
                draw_char(current_char, top_left, cell_size, @settings.character_color)
              when 2
                draw_char(next_char, top_left, cell_size, @settings.character_color, true)
              else
                if col.odd?
                  draw_char(current_char, top_left, cell_size, @settings.practice_color)
                else
                  draw_char(next_char, top_left, cell_size, @settings.practice_color, true)
                end
              end
            else
              color = col == 1 ? @settings.character_color : @settings.practice_color
              draw_char(current_char, top_left, cell_size, color) if input_index < characters.length
            end
          end

          @pdf.move_down cell_size
          input_index += 1
          input_index += 1 if is_youon_start && is_youon_pair
        end

        @pdf.start_new_page if input_index < characters.length
      end
    end
  end
end
