# GenkiYoshi

**GenkiYoshi** is a Ruby program to generate 原稿用紙 sheet(s) (Japanese manuscript paper) in two different "flavors": one with to-be-filled kanji and/or kana, and another with just the blank grid. This tool is great for practicing Japanese writing, whether it's kanji, kana, or mixed text.

[![Captura-de-tela-2025-01-24-125857.png](https://i.postimg.cc/BvRLTq53/Captura-de-tela-2025-01-24-125857.png)](https://postimg.cc/mcNgRW6p)

## Features
- **Character Sheets**: Generate 原稿用紙 sheet(s) with kana and kanji pre-filled in each cell.
- **Blank Character Sheets**: Generate only the blank grid, allowing freehand writing practice.
- **Custom Sizes (Coming Soon)**: Currently supports A4 paper size. More paper sizes are on the way.

---

## Table of Contents

1. [Installation](#installation)
2. [Usage](#usage)
3. [Contributing](#contributing)
4. [Credits](#credits)
5. [Coming Soon](#coming-soon)

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

### Step 2: Install Required Dependencies

#### Install Prawn Gem
GenkiYoshi uses the `prawn` gem to generate PDFs. Install the gem by running the following command:
```bash
gem install prawn
```

#### Install Poppler-Utils
Poppler-utils is required for PDF processing for printing in paper. Install it based on your operating system:

##### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install poppler-utils
```

##### MacOS
```bash
brew install poppler
```

##### Windows
1. Download the latest poppler release for Windows from [poppler releases](https://github.com/oschwartz10612/poppler-windows/releases/)
2. Extract the downloaded file
3. Add the `bin` directory to your system's PATH environment variable

### Step 3: Clone the GenkiYoshi repository
1. Open a terminal and run the following command to clone the project:
   ```bash
   git clone https://github.com/FragozoLeonardo/Genki-Yoshi.git
   ```
2. Navigate to the project directory:
   ```bash
   cd Genki-Yoshi
   ```

---

## Usage
Once Ruby is installed and the repository is cloned, you can start generating your 原稿用紙 sheet(s).

Here is a short tutorial on how use the CLI: https://youtu.be/UufPW4YT_UU

## Credits
[Nihilist.org.uk creator.](https://www.nihilist.org.uk/) - For the strokes order font.

## Contributing
Feel free to contribute by submitting issues or pull requests! We're open to adding more features, improving performance, or expanding the paper size options.

### Coming Soon

- Additional paper sizes (B5, A5, and more).
- Font options.
- Support for customizing the number of cells.
- Rspec tests in order to assegurate the application is working as intended.
- Improvements on the matter of OOP and Programming Principles such as SOLID.
- A web-based version with aesthetic features such as grid colour and further.

---

Happy writing with **GenkiYoshi**! 😊
