# WASM Source Files

This directory contains WebAssembly (WASM) source code for the WAMR ESP32 benchmark suite.

## Files

- **benchmark.c** - Pure WASM computational benchmarks
- **native_calls.c** - WASM functions that call native ESP32 functions
- **build_wasm.sh** - Build script to compile C → WASM → C header

## Prerequisites

### WASI SDK

Download and install WASI SDK 21+:

```bash
# Linux/macOS
wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-21/wasi-sdk-21.0-linux.tar.gz
tar xf wasi-sdk-21.0-linux.tar.gz
sudo mv wasi-sdk-21.0 /opt/wasi-sdk
```

The build script will auto-detect WASI SDK in these locations:
- `/opt/wasi-sdk`
- `/usr/local/wasi-sdk`
- `$HOME/wasi-sdk`
- `$HOME/.local/wasi-sdk`

Alternatively, set the `WASI_SDK` environment variable.

### WebAssembly Binary Toolkit (WABT) - Optional

For inspecting WASM modules:

```bash
# Ubuntu/Debian
sudo apt install wabt

# macOS
brew install wabt
```

## Building WASM Modules

Simply run the build script:

```bash
cd wasm_src
./build_wasm.sh
```

This will:
1. Compile `benchmark.c` → `benchmark.wasm`
2. Compile `native_calls.c` → `native_calls.wasm`
3. Generate C headers: `benchmark_wasm.h` and `native_calls_wasm.h`
4. Place headers in `../src/` for inclusion in main.cpp
5. Optionally generate `.wat` text format for inspection

## Benchmark Functions

### benchmark.c

Mathematical functions:
- `factorial_recursive(n)` - Recursive factorial
- `factorial_iterative(n)` - Iterative factorial
- `fibonacci_recursive(n)` - Recursive fibonacci
- `fibonacci_iterative(n)` - Iterative fibonacci
- `is_prime(n)` - Primality test
- `count_primes(n)` - Count primes up to n

Array operations:
- `array_sum(arr, len)` - Sum array elements
- `array_max(arr, len)` - Find maximum
- `array_reverse(arr, len)` - Reverse in place
- `array_copy(dest, src, len)` - Copy array
- `bubble_sort(arr, len)` - Sort array
- `binary_search(arr, len, target)` - Binary search

Combined workloads:
- `complex_workload(arr, len)` - Mixed math and memory operations
- `matrix_multiply_4x4(result, a, b)` - 4x4 matrix multiplication
- `checksum(data, len)` - Simple checksum with bit operations

### native_calls.c

Hardware interaction (via native ESP32 functions):
- `blink_led(pin, times, delay_ms)` - Blink LED pattern
- `read_sensor_category(pin)` - Read and categorize analog value
- `measure_elapsed(start_time)` - Calculate elapsed milliseconds
- `gpio_test_pattern(pin)` - Digital I/O test
- `print_benchmark_result(name, result, time_us)` - Serial output
- `complex_native_demo(led_pin, sensor_pin)` - Combined demo

## Compilation Flags

The build script uses these flags:

```bash
clang --target=wasm32 \      # Target WebAssembly 32-bit
    -O3 \                     # Optimize for speed
    -nostdlib \               # Don't link standard library
    -Wl,--no-entry \          # No main() entry point
    -Wl,--export-all \        # Export all functions
    -Wl,--allow-undefined \   # Allow undefined symbols (native functions)
    -o output.wasm input.c
```

### Why These Flags?

- **`--target=wasm32`**: Compile for 32-bit WebAssembly
- **`-O3`**: Maximum optimization for performance benchmarking
- **`-nostdlib`**: We use WAMR's built-in libc, not system libc
- **`--no-entry`**: No `main()` - we call exported functions directly
- **`--export-all`**: Make all functions callable from host
- **`--allow-undefined`**: Required for native function imports (e.g., `native_millis`)

## Inspecting WASM Modules

After building, you can inspect the generated WASM:

```bash
# View exported functions
wasm-objdump -x benchmark.wasm | grep -A 20 "Export section:"

# View text format
wasm2wat benchmark.wasm

# View disassembly
wasm-objdump -d benchmark.wasm
```

## Troubleshooting

### "WASI SDK not found"

Set the path manually:

```bash
export WASI_SDK=/path/to/wasi-sdk
./build_wasm.sh
```

### "clang: command not found"

WASI SDK is not installed or not in the detected paths. Install WASI SDK as shown in Prerequisites.

### "undefined symbol" errors in ESP32

This usually means:
1. Native function not registered in main.cpp
2. Signature mismatch between C declaration and registration
3. Function name typo

Check that all `extern` functions in `native_calls.c` match the registered natives in `main.cpp`.

### WASM module too large

Reduce optimization or strip unused functions:

```bash
# Optimize for size instead of speed
clang ... -Os ...

# Export only specific functions
clang ... -Wl,--export=function_name ...
```

## Adding New Functions

1. **Add to C file:**
   ```c
   int my_function(int arg) {
       return arg * 2;
   }
   ```

2. **Rebuild:**
   ```bash
   ./build_wasm.sh
   ```

3. **Call from main.cpp:**
   ```cpp
   uint32_t args[1] = {42};
   benchmark_module.callFunction("my_function", 1, args);
   uint32_t result = args[0];  // 84
   ```

## Performance Tips

- Use `-O3` for speed benchmarks
- Keep functions focused (single responsibility)
- Minimize function call depth for recursive functions
- Use iterative algorithms where possible
- Batch operations to reduce WASM↔native call overhead

## Further Reading

- [WASI SDK Documentation](https://github.com/WebAssembly/wasi-sdk)
- [WAMR Documentation](https://wamr.gitbook.io/)
- [WebAssembly Specification](https://webassembly.github.io/spec/)
- [WABT Tools](https://github.com/WebAssembly/wabt)
