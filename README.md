# Velo Media Downloader

### Preserve what you love ad free, tracking free, paywall free, nonsense free. Just paste the link, and you are good to go!

# Features
- 🎯 No ads or tracking
- 🔒 Bypass paywalls
- 💾 Direct media saving
- 🎵 Audio extraction support
- 🎬 Video quality options

# Requirements
- Qt 6.5+ (Qt Quick/QML)
- C++17 compatible compiler
- CMake 3.16+
- OpenSSL 1.1+

SQLite 3.x
## Building from Source

```bash
git clone https://github.com/Rinechxn/velodownloader.git
cd velodownloader
mkdir build && cd build
cmake ..
cmake --build .
```

## Development Setup

1. Install Qt Creator and Qt 6.5+
2. Clone the repository
3. Open `CMakeLists.txt` as project
4. Configure build settings
5. Build and run

## Project Structure

```
├── src/
│   ├── main.cpp
│   ├── database/
│   │   ├── dbmanager.cpp
│   │   └── dbmanager.hpp
│   ├── gui/
│   │   ├── framelesshelper.cpp
│   │   ├── framelesshelper.hpp
│   │   ├── mainwindow.cpp
│   │   └── mainwindow.hpp
│   └── utils/
│       ├── winnativeeventfilter.cpp
│       └── winnativeeventfilter.hpp
└── resources/
```

## Usage

1. Launch the application
2. Paste your media URL in the input field
3. Select quality options (if available)
4. Choose download location
5. Click download

## Example

1. Paste your media URL
2. Select quality options (if available)
3. Choose download location
4. Click download

## License

GPL License - feel free to use and modify as you wish!
