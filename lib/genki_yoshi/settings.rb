# frozen_string_literal: true

# lib/genki_yoshi/settings.rb
module GenkiYoshi
  class Settings
    attr_accessor :grid_color, :character_color, :practice_color, :selected_chars, :output_file

    def initialize
      @grid_color = '000000'
      @character_color = '000000'
      @practice_color = 'CCCCCC'
      @selected_chars = []
      @output_file = 'generated_genkoyoshi.pdf'
    end
  end
end
