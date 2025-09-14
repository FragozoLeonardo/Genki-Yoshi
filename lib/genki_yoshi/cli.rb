# frozen_string_literal: true

require_relative '../genki_yoshi'

module GenkiYoshi
  class CLI
    PROGRESS_ICONS = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'].freeze unless defined?(PROGRESS_ICONS)
    def initialize
      @settings = Settings.new
    end

    def run
      display_welcome_banner
      get_color_preferences
      select_characters
      get_output_filename
      return unless confirm_settings

      generate_pdf
      display_success_message
    end

    private

    def display_welcome_banner
      puts "\n#{'=' * 70}"
      puts 'Welcome to GenkiYoshi - Japanese Manuscript Paper Generator! 原稿用紙'
      puts '=' * 70
      puts "\nCreate beautiful Japanese writing practice sheets customized to your needs!"
      puts 'Created with ♥ for Japanese language learners'
      puts "\nTIP: For character combinations with smaller characters (like きょ, しゅ),"
      puts '     enter them together as one unit, NOT separately.'
      puts '     Good: きょ, しゅ, びょ'
      puts "     Bad:  き ょ, し ゅ, び ょ\n\n"
    end

    def get_color_preferences
      @settings.grid_color = get_color_preference('grid lines', '000000')
      @settings.character_color = get_color_preference('example characters', '000000')
      @settings.practice_color = get_color_preference('practice characters', 'CCCCCC')
    end

    def get_color_preference(element, default)
      puts "\nPlease enter the hex color code for #{element} (without #)"
      puts 'You can pick colors at: https://htmlcolorcodes.com/color-picker/'
      puts "Press Enter to use default color (##{default})"
      print '> '
      color = gets.chomp.upcase
      return default if color.empty?

      color.match?(/^[0-9A-F]{6}$/) ? color : default
    end

    def input_characters(set_name)
      puts "\nEnter #{set_name} characters (or press Enter to skip)"
      puts 'You can enter multiple characters with or without spaces'
      puts 'Remember: Enter combinations like きょ together, not separately'
      print '> '
      chars = gets.encode('utf-8', invalid: :replace, undef: :replace, replace: '').chomp
      CharacterProcessor.process_input(chars)
    end

    def select_characters
      puts "\nLet's input the characters you want to practice!"
      puts 'You can create up to three sets of characters.'

      set1 = input_characters('first set of')
      set2 = input_characters('second set of')
      set3 = input_characters('third set of')

      @settings.selected_chars = [set1, set2, set3].reject(&:empty?)

      return unless @settings.selected_chars.empty?

      puts "\nNo characters were entered. Please enter at least one set of characters."
      select_characters
    end

    def get_output_filename
      puts "\nEnter the output filename (default: generated_genkoyoshi.pdf)"
      print '> '
      filename = gets.chomp
      @settings.output_file = filename unless filename.empty?
      @settings.output_file += '.pdf' unless @settings.output_file.end_with?('.pdf')
    end

    def confirm_settings
      puts "\nCurrent Settings:"
      puts '================='
      puts "Grid Color: ##{@settings.grid_color}"
      puts "Example Character Color: ##{@settings.character_color}"
      puts "Practice Character Color: ##{@settings.practice_color}"
      puts "Output File: #{@settings.output_file}"
      puts 'Character Sets:'
      @settings.selected_chars.each_with_index do |set, index|
        puts "  Set #{index + 1}: #{set.join(' ')}"
      end

      print "\nProceed with these settings? (Y/n): "
      response = gets.chomp.downcase
      response == 'y' || response.empty?
    end

    def display_progress(step)
      PROGRESS_ICONS.each do |char|
        print "\r#{char} #{step}..."
        sleep 0.1
      end
    end

    def generate_pdf
      puts "\nGenerating your custom GenkiYoshi paper..."
      display_progress('Creating PDF')
      PDFGenerator.new(@settings).generate
    end

    def display_success_message
      puts "\n✨ Success! Your custom GenkiYoshi paper has been generated!"
      puts "📄 File saved as: #{@settings.output_file}"
      puts "\nThank you for using GenkiYoshi! がんばって！\n\n"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  $stdin.set_encoding(Encoding::UTF_8)
  GenkiYoshi::CLI.new.run
end
