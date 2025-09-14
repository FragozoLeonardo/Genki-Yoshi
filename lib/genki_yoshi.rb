# frozen_string_literal: true

require 'prawn'

# lib/genki_yoshi.rb
require_relative 'genki_yoshi/cli'
require_relative 'genki_yoshi/pdf_generator'
require_relative 'genki_yoshi/grid_drawer'
require_relative 'genki_yoshi/settings'
require_relative 'genki_yoshi/character_processor'
require_relative 'genki_yoshi/temporary_file_manager'

module GenkiYoshi
  VERSION = '3.0.0'
end
