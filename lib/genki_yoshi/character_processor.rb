# frozen_string_literal: true

# lib/genki_yoshi/character_processor.rb
module GenkiYoshi
  class CharacterProcessor
    class << self
      def process_input(input)
        input.scan(/\X/).reject { |c| c.match?(/[[:space:]]/) }
      end

      def youon_start?(char)
        char.match?(/[きぎしじちぢにひびぴみりキギシジチヂニヒビピミリ]/)
      end

      def youon_pair?(char)
        char&.match?(/[ゃゅょャュョ]/)
      end
    end
  end
end
