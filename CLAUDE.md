# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

test-wamr-project is a comprehensive benchmarking and testing project for the WAMR-ESP32-Arduino library. It demonstrates WebAssembly execution on ESP32 microcontrollers, comparing WASM interpreter performance against native C++ code, with support for both Xtensa and RISC-V architectures.

## Repository Structure

```
test-wamr-project/
├── src/
│   ├── main.cpp                  # Main benchmark application
│   ├── benchmark_wasm.h          # Compiled WASM module (interpreter)
│   ├── benchmark_aot_riscv.h     # AOT module for RISC-V (ESP32-C3/C6)
│   └── native_calls_wasm.h       # WASM module with native function calls
├── wasm_src/                     # WebAssembly source code
│   ├── benchmark.c               # Comprehensive benchmark functions
│   ├── native_calls.c            # Functions calling ESP32 native APIs
│   ├── build_wasm.sh             # Build script to compile C → WASM → header
│   └── README.md                 # Build instructions and documentation
├── platformio.ini                # PlatformIO configuration
└── CLAUDE.md                     # This file
```

## Project Purpose

This project serves multiple purposes:

1. **Performance Benchmarking**: Compare WASM interpreter vs native C++ execution
2. **AOT Testing**: Test Ahead-of-Time compilation on RISC-V architectures
3. **API Demonstration**: Show how to use WamrRuntime and WamrModule classes
4. **Native Function Integration**: Demonstrate calling ESP32 APIs from WASM
5. **Memory Profiling**: Test different heap/stack configurations
6. **Multi-Architecture Support**: Support both Xtensa and RISC-V ESP32 variants

## Architecture Support

### Current Support Matrix

| Architecture | Chips | Interpreter | AOT | Notes |
|-------------|--------|-------------|-----|-------|
| Xtensa | ESP32, ESP32-S2, ESP32-S3 | ✅ Works | ❌ Broken | LLVM Xtensa backend segfaults |
| RISC-V | ESP32-C3, ESP32-C6, ESP32-H2 | ✅ Works | ✅ Works | Full AOT support available |

### Board Configuration

**platformio.ini** supports multiple boards:

```ini
[platformio]
default_envs = esp32s3, esp32c3

[env:esp32s3]
board = esp32-s3-devkitc-1
# Xtensa architecture, interpreter only

[env:esp32c3]
board = esp32-c3-devkitm-1
# RISC-V architecture, AOT available
```

Build for specific board:
```bash
pio run -e esp32s3    # Build for ESP32-S3
pio run -e esp32c3    # Build for ESP32-C3
pio run               # Build all environments
```

## Key Components

### 1. Main Application (src/main.cpp)

**Structure:**
- Native C++ implementations of benchmark functions (for comparison)
- Native function wrappers for WASM to call ESP32 APIs
- Pthread wrapper functions for safe module loading
- Benchmark framework with microsecond timing
- Sequential module loading strategy (load → test → unload)

**Critical Implementation Details:**

#### Pthread Safety
WAMR requires pthread context for both `load()` and `callFunction()`. The implementation uses pthread wrappers:

```cpp
struct LoadContext {
  WamrModule* module;
  const uint8_t* wasm_bytes;
  uint32_t size;
  uint32_t stack_size;
  uint32_t heap_size;
  bool success;
};

void* load_thread_wrapper(void* arg);
bool load_in_thread(WamrModule* module, ...);
```

**Why:** Arduino's setup()/loop() are NOT pthreads, but WAMR's internal APIs require pthread context.

#### Sequential Module Loading
Due to memory constraints on ESP32-S3 without PSRAM, modules are loaded/unloaded sequentially:

```cpp
// Load benchmark module
load_in_thread(&benchmark_module, benchmark_wasm, ...);
// Run benchmarks
run_all_benchmarks();
// Unload to free memory
benchmark_module.unload();

// Load native_calls module
load_in_thread(&native_calls_module, native_calls_wasm, ...);
// Run demo
demo_native_functions();
// Unload
native_calls_module.unload();
```

**Memory Configuration:**
- Runtime heap: 128KB (shared across all modules)
- Per-module stack: 16KB
- Per-module heap: 32KB
- Total peak usage: ~200KB

#### Benchmark Methodology

**Internal Loop Design** (critical for accurate measurements):
```c
// WASM benchmark functions loop internally
int fibonacci_bench_1000(int n) {
    int result = 0;
    for (int i = 0; i < 1000; i++) {
        result = fibonacci_iterative(n);
    }
    return result;
}
```

This measures **actual WASM execution performance**, not call overhead.

**Benchmarking Pattern:**
```cpp
// WASM: Single call, 1000 iterations inside
uint32_t args[1] = {20};
unsigned long start = micros();
module.callFunction("fibonacci_bench_1000", 1, args);
wasm_time = micros() - start;

// Native: 1000 iterations to match
start = micros();
for (int i = 0; i < 1000; i++) {
    result = native_fibonacci_iterative(20);
}
native_time = micros() - start;
```

### 2. WASM Source Code (wasm_src/)

#### benchmark.c
Contains 25+ functions for comprehensive testing:
- **Math operations**: factorial, fibonacci (recursive/iterative), prime checking
- **Array operations**: sum, max, reverse, bubble_sort, binary_search
- **Memory operations**: checksum, matrix multiply (4x4)
- **Benchmark variants**: `*_bench_1000()` versions with internal loops

**Compilation target:** Standalone WASM (no WASI dependencies)

#### native_calls.c
Functions that call ESP32 native APIs registered via NativeSymbol array:
- `native_pin_mode()` - GPIO configuration
- `native_digital_write()` - GPIO control
- `native_millis()` - Timing
- `native_delay()` - Delay
- `blink_led()` - LED blinking demo using native calls
- `gpio_test_pattern()` - Complex GPIO pattern

**Purpose:** Demonstrate WASM ↔ native interop

#### build_wasm.sh
Automated build script:
1. Auto-detects WASI SDK installation
2. Compiles C → WASM with optimization (-O3)
3. Converts WASM → C header array (xxd)
4. Generates .wat files for inspection
5. Optionally compiles to AOT (for RISC-V)

**Usage:**
```bash
cd wasm_src
./build_wasm.sh              # Build WASM modules
./build_wasm.sh --aot        # Also build AOT for RISC-V
```

**Output files:**
- `benchmark.wasm` (5328 bytes) → `../src/benchmark_wasm.h`
- `native_calls.wasm` (1485 bytes) → `../src/native_calls_wasm.h`
- `benchmark_riscv.aot` → `../src/benchmark_aot_riscv.h` (if --aot)

## Build Process

### Building WASM Modules

**Prerequisites:**
- WASI SDK 21+ installed (auto-detected in `/opt/wasi-sdk` or `~/wasi-sdk-21.0`)
- wamrc compiler (for AOT, optional)

**Standard build:**
```bash
cd wasm_src
./build_wasm.sh
```

This generates headers that are `#include`d in main.cpp.

**With AOT compilation (RISC-V only):**
```bash
cd wasm_src
# Ensure wamrc is available
export WAMRC=~/workspace/wasm-micro-runtime/wamr-compiler/build/wamrc
./build_wasm.sh --aot
```

**Manual AOT compilation:**
```bash
# RISC-V (works)
wamrc --target=riscv32 --target-abi=ilp32d -o benchmark_riscv.aot benchmark.wasm

# Xtensa (currently broken - segfaults)
wamrc --target=xtensa -o benchmark_xtensa.aot benchmark.wasm
```

### Building the Project

**PlatformIO:**
```bash
# Build for ESP32-S3 (Xtensa, interpreter)
pio run -e esp32s3

# Build for ESP32-C3 (RISC-V, AOT available)
pio run -e esp32c3

# Upload and monitor
pio run -e esp32c3 -t upload -t monitor

# Clean build
pio run -t clean
```

**Arduino IDE:**
- Tools → Board → Select ESP32 variant
- Sketch → Verify/Compile
- Upload and open Serial Monitor (115200 baud)

## Conditional Compilation

### Architecture Detection

The project uses ESP-IDF macros for compile-time architecture detection:

```cpp
#if CONFIG_IDF_TARGET_ARCH_RISCV
    // RISC-V specific code (ESP32-C3/C6/H2)
    #include "benchmark_aot_riscv.h"
#elif CONFIG_IDF_TARGET_ARCH_XTENSA
    // Xtensa specific code (ESP32/S2/S3)
    #include "benchmark_wasm.h"
#endif
```

### Chip-Specific Detection

```cpp
#if CONFIG_IDF_TARGET_ESP32C3
    Serial.println("Running on ESP32-C3");
#elif CONFIG_IDF_TARGET_ESP32S3
    Serial.println("Running on ESP32-S3");
#endif
```

### Module Selection Pattern

```cpp
// Select module based on architecture and AOT availability
#if defined(USE_AOT) && defined(CONFIG_IDF_TARGET_ARCH_RISCV)
    #include "benchmark_aot_riscv.h"
    #define MODULE_DATA benchmark_aot_riscv
    #define MODULE_SIZE benchmark_aot_riscv_len
    #define MODULE_TYPE "AOT (RISC-V)"
#else
    #include "benchmark_wasm.h"
    #define MODULE_DATA benchmark_wasm
    #define MODULE_SIZE benchmark_wasm_len
    #define MODULE_TYPE "Interpreter"
#endif
```

To enable AOT in platformio.ini:
```ini
[env:esp32c3_aot]
extends = env:esp32c3
build_flags = -DUSE_AOT
```

## Performance Expectations

### Interpreter Mode (All Architectures)

Typical results on ESP32-S3 @ 240MHz:

| Benchmark | WASM (μs) | Native (μs) | Overhead |
|-----------|-----------|-------------|----------|
| Fibonacci(20) x1000 | ~9500 | ~200 | ~47x |
| Factorial(10) x1000 | ~5700 | ~150 | ~38x |
| Computation x1000 | ~9700 | ~210 | ~46x |

**Note:** WASM overhead of 40-50x is expected for interpreter mode. This translates to ~50-70% of native performance per operation.

### AOT Mode (RISC-V Only)

Expected results on ESP32-C3 @ 160MHz with AOT:

| Benchmark | AOT (μs) | Native (μs) | Overhead |
|-----------|----------|-------------|----------|
| Fibonacci(20) x1000 | ~3000 | ~250 | ~12x |
| Factorial(10) x1000 | ~2000 | ~180 | ~11x |
| Computation x1000 | ~3200 | ~260 | ~12x |

**AOT provides 2-3x speedup** over interpreter, achieving ~90-95% of native performance.

### API Call Overhead

- `callFunction()` (safe API): ~100-500μs per call (includes pthread creation)
- `callFunctionRaw()` (advanced): ~10-50μs per call (must be in pthread context)

For high-frequency calls (>100 Hz), use `callFunctionRaw()` from a custom pthread.

## Memory Constraints

### ESP32-S3 (without PSRAM)
- Total RAM: ~520KB
- Available heap: ~240KB after Arduino framework
- Strategy: Sequential module loading (load → run → unload)

### ESP32-C3
- Total RAM: ~400KB
- Available heap: ~200KB after Arduino framework
- Strategy: Same sequential loading, smaller modules

### Recommended Configurations

**Small modules (<5KB WASM):**
```cpp
WamrRuntime::begin(64 * 1024);  // 64KB runtime heap
module.load(wasm, size, 8192, 16384);  // 8KB stack, 16KB heap
```

**Medium modules (5-20KB WASM):**
```cpp
WamrRuntime::begin(128 * 1024);  // 128KB runtime heap
module.load(wasm, size, 16384, 32768);  // 16KB stack, 32KB heap
```

**Large modules (>20KB WASM):**
```cpp
WamrRuntime::begin(256 * 1024);  // 256KB runtime heap
module.load(wasm, size, 32768, 65536);  // 32KB stack, 64KB heap
// Only one large module at a time without PSRAM
```

## Native Function Registration

Native functions are registered using the NativeSymbol array:

```cpp
static NativeSymbol native_symbols[] = {
    {"native_pin_mode", (void*)native_pin_mode_wrapper, "(ii)", NULL},
    {"native_digital_write", (void*)native_digital_write_wrapper, "(ii)", NULL},
    {"native_millis", (void*)native_millis_wrapper, "()i", NULL},
    {"native_delay", (void*)native_delay_wrapper, "(i)", NULL}
};

if (!module.registerNatives("env", native_symbols,
                             sizeof(native_symbols) / sizeof(NativeSymbol))) {
    Serial.println("Failed to register native functions!");
}
```

**Signature format:**
- `(ii)` - Two int parameters, no return
- `()i` - No parameters, returns int
- `(i)` - One int parameter, no return
- `(ii)i` - Two int parameters, returns int

## Common Development Tasks

### Adding a New WASM Function

1. **Add to benchmark.c:**
```c
int my_new_function(int x) {
    return x * x;
}
```

2. **Rebuild WASM:**
```bash
cd wasm_src && ./build_wasm.sh
```

3. **Call from main.cpp:**
```cpp
uint32_t args[1] = {42};
if (module.callFunction("my_new_function", 1, args)) {
    Serial.printf("Result: %u\n", args[0]);
}
```

### Adding a New Native Function

1. **Create wrapper in main.cpp:**
```cpp
static void my_native_wrapper(wasm_exec_env_t exec_env, int param) {
    // ESP32 native code here
    digitalWrite(LED_PIN, param);
}
```

2. **Register in native_symbols array:**
```cpp
{"my_native_func", (void*)my_native_wrapper, "(i)", NULL}
```

3. **Call from WASM (native_calls.c):**
```c
extern void my_native_func(int param);

void wasm_function() {
    my_native_func(1);
}
```

### Adding a New Benchmark

1. **Add function to benchmark.c:**
```c
int my_benchmark(int n) {
    // Implementation
}

// Add bench_1000 version for accurate measurement
int my_benchmark_bench_1000(int n) {
    int result = 0;
    for (int i = 0; i < 1000; i++) {
        result = my_benchmark(n);
    }
    return result;
}
```

2. **Add native equivalent to main.cpp:**
```cpp
static int native_my_benchmark(int n) {
    // Same implementation
}
```

3. **Add benchmark function:**
```cpp
BenchmarkResult benchmark_my_test(int n) {
    BenchmarkResult result = {"My Test x1000", 0, 0, 0, 0, 0};

    // WASM version
    uint32_t args[1] = {n};
    unsigned long start = micros();
    module.callFunction("my_benchmark_bench_1000", 1, args);
    result.wasm_time_us = micros() - start;
    result.wasm_result = args[0];

    // Native version
    start = micros();
    for (int i = 0; i < 1000; i++) {
        result.native_result = native_my_benchmark(n);
    }
    result.native_time_us = micros() - start;

    return result;
}
```

4. **Call from loop():**
```cpp
auto result = benchmark_my_test(10);
print_benchmark_result(result);
```

## Debugging

### Serial Output

Set baud rate to 115200:
```cpp
Serial.begin(115200);
```

**Key debug points:**
- Runtime initialization status
- Module load success/failure
- Memory allocation sources (PSRAM vs internal)
- Function call results
- Benchmark timings

### Common Issues

**Issue 1: Module fails to load**
- Check available heap: `ESP.getFreeHeap()`
- Reduce stack/heap sizes in `module.load()`
- Unload other modules first
- Try smaller WASM module

**Issue 2: Function not found**
- Verify function is exported in C code
- Check build_wasm.sh exports all needed functions
- Use `--export-all` or explicit `-Wl,--export=func_name`

**Issue 3: Segmentation fault**
- Ensure callFunction() is used (not callFunctionRaw()) from Arduino code
- Check native function signatures match registration
- Verify WASM doesn't overflow stack/heap

**Issue 4: Poor performance**
- Use `*_bench_1000()` functions for accurate measurement
- Disable Serial printing during benchmarks
- Use -O3 optimization when compiling WASM
- Try AOT mode on RISC-V architecture

**Issue 5: Out of memory**
- Use sequential loading (unload modules between tests)
- Reduce runtime heap size
- Smaller per-module stack/heap
- Consider PSRAM-enabled board (ESP32-S3)

### Memory Debugging

```cpp
Serial.printf("Free heap: %u bytes\n", ESP.getFreeHeap());
Serial.printf("Largest block: %u bytes\n", ESP.getMaxAllocHeap());
Serial.printf("PSRAM: %s\n", ESP.getPsramSize() > 0 ? "Available" : "Not available");
```

## Testing Workflow

### Complete Test Cycle

1. **Modify WASM source:**
```bash
vim wasm_src/benchmark.c
```

2. **Rebuild WASM modules:**
```bash
cd wasm_src && ./build_wasm.sh
```

3. **Build and upload for ESP32-S3 (interpreter):**
```bash
pio run -e esp32s3 -t upload -t monitor
```

4. **Build and upload for ESP32-C3 (AOT):**
```bash
# First build AOT module
cd wasm_src && ./build_wasm.sh --aot
# Then build and upload
pio run -e esp32c3 -t upload -t monitor
```

5. **Compare results:**
- Check benchmark timings
- Verify results match between WASM and native
- Compare ESP32-S3 (interpreter) vs ESP32-C3 (AOT)

## Known Limitations

1. **Xtensa AOT broken**: LLVM Xtensa backend segfaults when compiling AOT
2. **PSRAM not utilized**: Current version doesn't explicitly use PSRAM for modules
3. **Single module active**: Memory constraints require sequential loading
4. **No WASI support**: Standalone WASM only (no filesystem, environment, etc.)
5. **Limited threading**: Lib pthread disabled to reduce size

## Future Enhancements

- [ ] Multi-module concurrent loading with PSRAM
- [ ] WASI support for filesystem access
- [ ] Fix Xtensa AOT compilation (upstream LLVM issue)
- [ ] Add more complex benchmarks (JSON parsing, crypto, etc.)
- [ ] Profile-guided optimization (PGO) for AOT
- [ ] Web dashboard for benchmark results
- [ ] Automated regression testing

## Dependencies

- **wamr-esp32-arduino** library (local: `../wamr-esp32-arduino`)
- **Arduino-ESP32** framework (via PlatformIO)
- **WASI SDK 21+** (for building WASM)
- **wamrc** compiler (optional, for AOT)

## Version Compatibility

- PlatformIO: 6.1.0+
- ESP32 Arduino: 3.0.0+
- WAMR: 2.4.3 (via library)
- WASI SDK: 21.0+
- ESP-IDF: 5.0+ (via Arduino framework)

## References

- [WAMR GitHub](https://github.com/bytecodealliance/wasm-micro-runtime)
- [WAMR Documentation](https://wamr.gitbook.io/)
- [WebAssembly Spec](https://webassembly.github.io/spec/)
- [WASI SDK](https://github.com/WebAssembly/wasi-sdk)
- [ESP32 Arduino Core](https://github.com/espressif/arduino-esp32)
