# frozen_string_literal: true

# spec/integration_spec.rb
require 'spec_helper'

RSpec.describe 'GenkiYoshi Integration' do
  it 'generates a complete PDF from user input' do
    # Mock user input
    allow_any_instance_of(GenkiYoshi::CLI).to receive(:gets).and_return(
      "\n", # grid color default
      "\n", # example color default
      "\n", # practice color default
      "あいうえお\n", # characters
      "\n", # skip second set
      "\n", # skip third set
      "\n", # default filename
      "Y\n" # confirm
    )

    # Run the CLI
    cli = GenkiYoshi::CLI.new
    expect { cli.run }.not_to raise_error

    # Check if PDF was created
    expect(File.exist?('generated_genkoyoshi.pdf')).to be true

    # Cleanup
    File.delete('generated_genkoyoshi.pdf') if File.exist?('generated_genkoyoshi.pdf')
  end
end
