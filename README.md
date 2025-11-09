# WAMR ESP32 Test Project

This is a simple PlatformIO project demonstrating how to use the WAMR-ESP32-Arduino library.

## Setup

### 1. Project Structure
```
test-wamr-project/
├── platformio.ini          # PlatformIO configuration
├── src/
│   └── main.cpp           # Your application code
└── lib/                   # Optional: place libraries here
```

### 2. Configure platformio.ini

Add the WAMR library to your `platformio.ini`:

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
lib_deps =
    file://../wamr-esp32-arduino  # Local path to library
```

**Alternative options for lib_deps:**

```ini
# Option 1: Local file path (relative or absolute)
lib_deps = file://../wamr-esp32-arduino

# Option 2: Git repository (once published)
lib_deps = https://github.com/yourname/wamr-esp32-arduino.git

# Option 3: PlatformIO Library Registry (once published)
lib_deps = WAMR-ESP32
```

### 3. Include and Use in Your Code

```cpp
#include <Arduino.h>
#include <WAMR.h>

WamrModule module;

void setup() {
  Serial.begin(115200);

  // Initialize WAMR runtime
  if (!WamrRuntime::begin(128 * 1024)) {  // 128KB heap
    Serial.println("Failed to init WAMR!");
    return;
  }

  // Load WASM module
  if (!module.load(wasm_bytes, wasm_size)) {
    Serial.println("Failed to load module!");
    return;
  }

  // Call WASM function
  uint32_t args[2] = {42, 58};
  if (module.callFunction("add", 2, args)) {
    Serial.printf("Result: %u\n", args[0]);
  }
}

void loop() {
  // Your code here
}
```

## Building

```bash
# Build the project
pio run

# Build and upload to ESP32
pio run --target upload

# Open serial monitor
pio device monitor
```

## Memory Requirements

- **Runtime heap**: 128KB (configurable in `WamrRuntime::begin()`)
- **Module heap**: 32KB default (configurable in `module.load()`)
- **Stack**: 16KB default (configurable in `module.load()`)
- **Flash**: ~350-400KB for basic WAMR runtime

## Example Output

```
=== WAMR ESP32 Test ===
Initializing WAMR runtime...
WAMR runtime initialized successfully

Loading WASM module...
WASM module loaded successfully

Calling WASM function add(42, 58)...
Result: 100
Expected: 100

✓ Test PASSED!

Memory usage:
[Memory statistics here]
```

## Compiling WASM Modules

To create WASM modules, use WASI SDK:

```bash
# Install WASI SDK
wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-21/wasi-sdk-21.0-linux.tar.gz
tar xf wasi-sdk-21.0-linux.tar.gz

# Compile C to WASM
wasi-sdk-21.0/bin/clang --target=wasm32 -O3 \
    -nostdlib -Wl,--no-entry \
    -Wl,--export=add \
    -o add.wasm add.c

# Convert to C byte array
xxd -i add.wasm > add.wasm.h
```

See `../wamr-esp32-arduino/docs/BUILDING_WASM.md` for more details.

## Troubleshooting

### Build fails with "WAMR.h: No such file"
- Make sure the library path in `platformio.ini` is correct
- Try rebuilding: `pio run --target clean && pio run`

### Out of memory errors
- Increase heap size in `WamrRuntime::begin(size)`
- Reduce module heap/stack in `module.load()`
- Use ESP32-S3 with PSRAM for larger applications

### Module fails to load
- Check that WASM binary is valid
- Verify the module doesn't use unsupported features (WASI, threading, etc.)
- Enable debug output with `Serial` to see error messages

## Resources

- [WAMR Documentation](https://wamr.gitbook.io/)
- [WebAssembly Specification](https://webassembly.github.io/spec/)
- [PlatformIO ESP32 Platform](https://docs.platformio.org/en/latest/platforms/espressif32.html)
