# frozen_string_literal: true

# spec/character_processor_spec.rb
require 'spec_helper'

RSpec.describe GenkiYoshi::CharacterProcessor do
  describe '.process_input' do
    it 'processes Japanese characters correctly' do
      input = 'あいうえお かきくけこ'
      result = described_class.process_input(input)
      expect(result).to eq(%w[あ い う え お か き く け こ])
    end

    it 'handles youon combinations correctly' do
      input = 'きょしゅびょ'
      result = described_class.process_input(input)
      expect(result).to eq(%w[き ょ し ゅ び ょ])
    end
  end

  describe '.youon_start?' do
    it 'returns true for youon starting characters' do
      expect(described_class.youon_start?('き')).to be true
      expect(described_class.youon_start?('し')).to be true
    end

    it 'returns false for non-youon starting characters' do
      expect(described_class.youon_start?('あ')).to be false
      expect(described_class.youon_start?('か')).to be false
    end
  end

  describe '.youon_pair?' do
    it 'returns true for youon pair characters' do
      expect(described_class.youon_pair?('ょ')).to be true
      expect(described_class.youon_pair?('ゅ')).to be true
    end

    it 'returns false for non-youon pair characters' do
      expect(described_class.youon_pair?('あ')).to be false
      expect(described_class.youon_pair?('か')).to be false
    end
  end
end
