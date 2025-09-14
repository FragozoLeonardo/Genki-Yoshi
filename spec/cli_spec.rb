# frozen_string_literal: true

# spec/cli_spec.rb
require 'spec_helper'

RSpec.describe GenkiYoshi::CLI do
  let(:cli) { described_class.new }

  describe '#get_color_preference' do
    it 'returns default color when input is empty' do
      allow(cli).to receive(:gets).and_return("\n")
      expect(cli.send(:get_color_preference, 'grid lines', '000000')).to eq('000000')
    end

    it 'returns valid color code' do
      allow(cli).to receive(:gets).and_return("FF0000\n")
      expect(cli.send(:get_color_preference, 'grid lines', '000000')).to eq('FF0000')
    end

    it 'returns default for invalid color code' do
      allow(cli).to receive(:gets).and_return("invalid\n")
      expect(cli.send(:get_color_preference, 'grid lines', '000000')).to eq('000000')
    end
  end

  describe '#confirm_settings' do
    it 'returns true for Y response' do
      allow(cli).to receive(:gets).and_return("Y\n")
      expect(cli.send(:confirm_settings)).to be true
    end

    it 'returns true for y response' do
      allow(cli).to receive(:gets).and_return("y\n")
      expect(cli.send(:confirm_settings)).to be true
    end

    it 'returns true for empty response' do
      allow(cli).to receive(:gets).and_return("\n")
      expect(cli.send(:confirm_settings)).to be true
    end

    it 'returns false for n response' do
      allow(cli).to receive(:gets).and_return("n\n")
      expect(cli.send(:confirm_settings)).to be false
    end
  end

  describe '#input_characters' do
    it 'processes Japanese characters correctly' do
      allow(cli).to receive(:gets).and_return("あいうえお\n")
      result = cli.send(:input_characters, 'test')
      expect(result).to eq(%w[あ い う え お])
    end

    it 'handles youon combinations correctly' do
      allow(cli).to receive(:gets).and_return("きょしゅ\n")
      result = cli.send(:input_characters, 'test')
      expect(result).to eq(%w[き ょ し ゅ])
    end

    it 'returns empty array for empty input' do
      allow(cli).to receive(:gets).and_return("\n")
      result = cli.send(:input_characters, 'test')
      expect(result).to eq([])
    end
  end
end
