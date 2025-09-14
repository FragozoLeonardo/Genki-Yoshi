# frozen_string_literal: true

# spec/grid_drawer_spec.rb
require 'spec_helper'

RSpec.describe GenkiYoshi::GridDrawer do
  let(:settings) { GenkiYoshi::Settings.new }
  let(:pdf) { double('pdf') }
  let(:grid_drawer) { described_class.new(pdf, settings) }

  before do
    # Mocks específicos para os métodos usados pelo GridDrawer
    allow(pdf).to receive(:width_of).and_return(20)
    allow(pdf).to receive(:fill_color)
    allow(pdf).to receive(:draw_text)
    allow(pdf).to receive(:stroke_color=) # Adicione esta linha
    allow(pdf).to receive(:stroke_rectangle)
    allow(pdf).to receive(:dash)
    allow(pdf).to receive(:stroke_line)
    allow(pdf).to receive(:undash)
    allow(pdf).to receive(:move_down)
    allow(pdf).to receive(:cursor).and_return(700)
    allow(pdf).to receive(:bounds).and_return(double(width: 500, height: 700))
    allow(pdf).to receive(:update_height).and_return(nil)
    allow(pdf).to receive(:start_new_page) # Adicione esta linha se necessário
  end

  describe '#draw_grid_cell' do
    it 'draws a grid cell without errors' do
      expect { grid_drawer.draw_grid_cell([0, 0], 50) }.not_to raise_error
    end
  end

  describe '#draw_char' do
    it 'draws normal characters correctly' do
      expect { grid_drawer.draw_char('あ', [0, 0], 50, '000000') }.not_to raise_error
    end

    it 'draws small characters correctly' do
      expect { grid_drawer.draw_char('ょ', [0, 0], 50, '000000', true) }.not_to raise_error
    end
  end

  describe '#draw_grid_page' do
    it 'handles youon pairs correctly' do
      characters = %w[き ょ]
      expect { grid_drawer.draw_grid_page(characters, 1, 2, 50) }.not_to raise_error
    end

    it 'handles regular characters correctly' do
      characters = %w[あ い う]
      expect { grid_drawer.draw_grid_page(characters, 1, 3, 50) }.not_to raise_error
    end
  end
end
