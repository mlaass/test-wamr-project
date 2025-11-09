# WASM to C Header Conversion

This project includes a Python script to convert WASM files into C/C++ header files for embedding in your ESP32 firmware.

## Quick Start

### 1. Create a WAT file (WebAssembly Text format)

Example `add.wat`:
```wat
(module
  (func $add (export "add") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add
  )
)
```

### 2. Compile WAT to WASM

```bash
wat2wasm add.wat -o add.wasm
```

**Note:** You need the WebAssembly Binary Toolkit (WABT) installed:
- Ubuntu/Debian: `sudo apt install wabt`
- macOS: `brew install wabt`
- Or download from: https://github.com/WebAssembly/wabt

### 3. Convert WASM to C Header

```bash
python3 wasm_to_header.py add.wasm
```

This generates `add.h` with:
- `add_wasm[]` - byte array containing the WASM module
- `add_wasm_len` - length of the array

### 4. Use in Your Code

```cpp
#include "add.h"

// Or copy the arrays directly into your source file
const unsigned char add_wasm[] = { /* ... */ };
const unsigned int add_wasm_len = 41;
```

## Script Usage

```bash
python3 wasm_to_header.py input.wasm [output.h]
```

- If `output.h` is not specified, it defaults to `<input_name>.h`
- Array names are derived from the input filename (e.g., `my_module.wasm` → `my_module_wasm[]`)

## Example Workflow

```bash
# Write your WebAssembly function
cat > multiply.wat << 'EOF'
(module
  (func $multiply (export "multiply") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.mul
  )
)
EOF

# Compile to WASM
wat2wasm multiply.wat -o multiply.wasm

# Convert to header
python3 wasm_to_header.py multiply.wasm

# Now use multiply_wasm[] and multiply_wasm_len in your code
```

## Tips

- Keep WASM modules small for ESP32 (limited RAM)
- Test your WAT syntax with `wat2wasm --validate`
- Use `wasm2wat` to decompile WASM back to WAT for inspection
- The script formats output with 12 bytes per line for readability
