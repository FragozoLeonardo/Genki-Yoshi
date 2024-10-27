# GenkiYoshi

**GenkiYoshi** is a Ruby program to generate _原稿用紙_ (Japanese manuscript paper) in two different "flavors": one with pre-filled kanji and kana, and another with just the blank grid. This tool is great for practicing Japanese writing, whether it's kanji, kana, or mixed text.

## Features

- **Kanji Sheets**: Generate _原稿用紙_ with kanji and kana pre-filled in each cell.
- **Blank Kanji Sheets**: Generate only the blank grid, allowing freehand writing practice.
- **Custom Sizes (Coming Soon)**: Currently supports A4 paper size. More paper sizes are on the way.

---

## Table of Contents
1. [Installation](#installation)
2. [Usage](#usage)
   - [Kanji Sheets](#kanji-sheets)
   - [Blank Kanji Sheets](#blank-kanji-sheets)
3. [Contributing](#contributing)
4. [License](#license)

---

## Installation

To start using GenkiYoshi, follow the instructions below to install Ruby and set up the project.

### Step 1: Install Ruby

If you don't have Ruby installed on your system, follow the instructions below for your platform.

#### Windows
1. Download the Ruby Installer from [RubyInstaller](https://rubyinstaller.org/).
2. Run the installer and ensure you select the option to add Ruby to your system's PATH.

#### MacOS
1. You can install Ruby via Homebrew:
   ```bash
   brew install ruby
   ```

#### Linux
1. Install Ruby using your package manager. For example, on Ubuntu:
   ```bash
   sudo apt install ruby-full
   ```

### Step 2: Clone the GenkiYoshi repository

1. Open a terminal and run the following command to clone the project:
   ```bash
   git clone https://github.com/FragozoLeonardo/GenkiYoshi.git
   ```

2. Navigate to the project directory:
   ```bash
   cd GenkiYoshi
   ```

---

## Usage

Once Ruby is installed and the repository is cloned, you can start generating your _原稿用紙_ sheets.

### Kanji Sheets

To generate a _原稿用紙_ filled with kanji and kana characters:

1. Open the `kanji_sheets.rb` file.
2. In the file, you will see an `input_kanji_kana` array. This is where you will input the characters you want to appear on the sheet:
   ```ruby
   input_kanji_kana = ["日", "本", "語", "学", "習"]
   ```

3. Run the script in your terminal:
   ```bash
   ruby kanji_sheets.rb
   ```

This will generate an A4-size _原稿用紙_ with the characters you specified in each cell.

### Blank Kanji Sheets

If you want to generate a blank grid for freehand practice:

1. Open the `kanji_sheets_blank.rb` file.
2. Simply run the script:
   ```bash
   ruby kanji_sheets_blank.rb
   ```

This will generate a blank A4-sized _原稿用紙_ for manual writing.

---

## Contributing

Feel free to contribute by submitting issues or pull requests! We're open to adding more features, improving performance, or expanding the paper size options.

### Coming Soon
- Additional paper sizes (B5, A5, and more).
- Support for customizing the number of cells.

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

Happy writing with **GenkiYoshi**!