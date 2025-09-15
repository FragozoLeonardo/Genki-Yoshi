# GenkiYoshi

**GenkiYoshi** is a Ruby CLI application that generates customizable Japanese manuscript paper (原稿用紙) for writing practice. The application now features a modular OOP architecture following SOLID principles, comprehensive test coverage, and improved maintainability.

[![Captura-de-tela-2025-01-24-135307.png](https://i.postimg.cc/HnN4x3b2/Captura-de-tela-2025-01-24-135307.png)](https://postimg.cc/SYWz16T2)

## Features
- **Custom Character Sheets**: Generate 原稿用紙 sheets with kana and kanji pre-filled in each cell
- **Blank Character Sheets**: Generate only the blank grid for freehand writing practice
- **Customizable Colors**: Choose custom colors for grid lines, example characters, and practice characters
- **Multiple Character Sets**: Input up to three sets of characters for varied practice
- **UTF-8 Support**: Full support for Japanese characters and combinations
- **Modular Architecture**: Clean, maintainable code following SOLID principles

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Running Tests](#running-tests)
5. [Contributing](#contributing)
6. [Credits](#credits)
7. [Roadmap](#roadmap)

---

## Architecture Overview

GenkiYoshi now follows a modular Object-Oriented Programming (OOP) architecture with separation of concerns:

### Core Components

- **CLI**: Handles user interaction and workflow coordination
- **PDFGenerator**: Manages PDF creation and generation
- **GridDrawer**: Responsible for drawing grid cells and characters
- **CharacterProcessor**: Processes and validates character input
- **Settings**: Manages application configuration and preferences
- **TemporaryFileManager**: Handles file operations and conversions

### Design Principles

- **SOLID Compliance**: Each class has a single responsibility
- **Test-Driven Development**: Comprehensive RSpec test suite
- **Dependency Injection**: Loose coupling between components
- **Error Handling**: Robust error handling and user feedback

## Installation

### Prerequisites

- Ruby 2.7+ (recommended 3.0+)
- Poppler-utils for PDF processing
- Japanese font support (optional, for better rendering)

### Step 1: Install Ruby

#### Windows
1. Download the Ruby Installer from [RubyInstaller](https://rubyinstaller.org/)
2. Run the installer and ensure you select the option to add Ruby to your system's PATH

#### MacOS
```bash
brew install ruby
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt install ruby-full
```

### Step 2: Install Poppler-Utils

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install poppler-utils
```

#### MacOS
```bash
brew install poppler
```

#### Windows
1. Download the latest poppler release for Windows from [poppler releases](https://github.com/oschwartz10612/poppler-windows/releases/)
2. Extract the downloaded file
3. Add the `bin` directory to your system's PATH environment variable

### Step 3: Install GenkiYoshi

1. Clone the repository:
```bash
git clone https://github.com/FragozoLeonardo/Genki-Yoshi.git
cd Genki-Yoshi
```

2. Install dependencies:
```bash
bundle install
```

3. (Optional) Install Japanese fonts for better character rendering:
```bash
# Ubuntu/Debian
sudo apt-get install fonts-ipafont fonts-noto-cjk

# MacOS
brew install --cask font-noto-sans-cjk-jp
```

## Usage

Run the application with:
```bash
./genki-yoshi
```

Or using Ruby directly:
```bash
ruby -I lib lib/genki_yoshi/cli.rb
```

The interactive CLI will guide you through:
1. Color customization for grid lines and characters
2. Character input (up to three sets)
3. Output filename selection
4. Confirmation before generation

[Here](https://youtu.be/FeBbXmcPcR0) is a short YouTube tutorial on how to use the CLI.

## Running Tests

GenkiYoshi includes a comprehensive test suite using RSpec. To run the tests:

```bash
# Run all tests
bundle exec rspec

# Run specific test files
bundle exec rspec spec/pdf_generator_spec.rb
bundle exec rspec spec/grid_drawer_spec.rb

# Run with detailed output
bundle exec rspec --format documentation
```

The test suite covers:
- Unit tests for individual components
- Integration tests for workflow validation
- Error handling and edge cases
- Mocking of external dependencies

## Contributing

We welcome contributions! Please feel free to submit issues, feature requests, or pull requests.

### Development Guidelines

1. Follow SOLID principles and OOP best practices
2. Write tests for new features using RSpec
3. Ensure all existing tests pass before submitting
4. Use descriptive commit messages
5. Update documentation as needed

### Setting Up Development Environment

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/Genki-Yoshi.git`
3. Create a feature branch: `git checkout -b feature/your-feature`
4. Make your changes and add tests
5. Run tests: `bundle exec rspec`
6. Commit your changes: `git commit -am 'Add new feature'`
7. Push to the branch: `git push origin feature/your-feature`
8. Submit a pull request

## Credits


- [Nihilist.org.uk](https://www.nihilist.org.uk/) - For the KanjiStrokeOrders font
- Ruby community for excellent gems like Prawn and RSpec
- Contributors and users who provide feedback and suggestions

## Roadmap

### Short-term Goals
- [ ] Additional paper sizes (B5, A5, and more)
- [ ] Font customization options
- [ ] Configurable grid density (cells per page)
- [ ] Export to image formats (PNG, JPEG)

### Medium-term Goals
- [ ] Web-based version with GUI
- [ ] Pre-defined character sets (JLPT levels, etc.)

### Long-term Vision
- [ ] Mobile application
- [ ] Progress tracking and analytics
---

Happy writing with **GenkiYoshi**! がんばって! 😊
