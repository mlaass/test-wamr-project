#!/bin/bash
#
# build_wasm.sh - Build WASM modules and generate C headers
#
# This script compiles C source files to WASM using WASI SDK and
# converts them to C header files for embedding in Arduino/ESP32 projects.
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================================
# Configuration
# ============================================================================

# Auto-detect WASI SDK location
WASI_SDK_PATHS=(
    "/opt/wasi-sdk"
    "/usr/local/wasi-sdk"
    "$HOME/wasi-sdk"
    "$HOME/.local/wasi-sdk"
)

WASI_SDK=""
for path in "${WASI_SDK_PATHS[@]}"; do
    if [ -d "$path" ]; then
        WASI_SDK="$path"
        break
    fi
done

if [ -z "$WASI_SDK" ]; then
    echo -e "${RED}Error: WASI SDK not found in standard locations${NC}"
    echo "Please install WASI SDK or set WASI_SDK environment variable"
    exit 1
fi

CLANG="$WASI_SDK/bin/clang"
WASM2WAT="wasm2wat"
WASM_OBJDUMP="wasm-objdump"

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR"
OUTPUT_DIR="$SCRIPT_DIR"
HEADER_DIR="$SCRIPT_DIR/../src"

# Python script for header generation
WASM_TO_HEADER="../wasm_to_header.py"

echo -e "${GREEN}WASM Build Script${NC}"
echo "==============================================="
echo "WASI SDK: $WASI_SDK"
echo "Source:   $SRC_DIR"
echo "Output:   $OUTPUT_DIR"
echo "Headers:  $HEADER_DIR"
echo ""

# ============================================================================
# Helper Functions
# ============================================================================

compile_wasm() {
    local src_file=$1
    local output_name=$2
    local extra_flags=$3

    echo -e "${YELLOW}Compiling $src_file...${NC}"

    # Compile to WASM
    $CLANG --target=wasm32 \
        -O3 \
        -nostdlib \
        -Wl,--no-entry \
        -Wl,--export-all \
        -Wl,--allow-undefined \
        $extra_flags \
        -o "$OUTPUT_DIR/${output_name}.wasm" \
        "$SRC_DIR/$src_file"

    if [ $? -eq 0 ]; then
        local size=$(stat -f%z "$OUTPUT_DIR/${output_name}.wasm" 2>/dev/null || stat -c%s "$OUTPUT_DIR/${output_name}.wasm")
        echo -e "${GREEN}✓ Compiled: ${output_name}.wasm ($size bytes)${NC}"
    else
        echo -e "${RED}✗ Failed to compile $src_file${NC}"
        exit 1
    fi
}

generate_header() {
    local wasm_file=$1
    local output_name=$2

    echo -e "${YELLOW}Generating header for $wasm_file...${NC}"

    if [ -f "$WASM_TO_HEADER" ]; then
        python3 "$WASM_TO_HEADER" \
            "$OUTPUT_DIR/${wasm_file}.wasm" \
            "$HEADER_DIR/${output_name}.h" \
            "${output_name}"

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Generated: ${output_name}.h${NC}"
        else
            echo -e "${RED}✗ Failed to generate header${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}Warning: wasm_to_header.py not found, using xxd instead${NC}"
        xxd -i "$OUTPUT_DIR/${wasm_file}.wasm" > "$HEADER_DIR/${output_name}.h"
        echo -e "${GREEN}✓ Generated: ${output_name}.h (using xxd)${NC}"
    fi
}

inspect_wasm() {
    local wasm_file=$1

    if command -v $WASM_OBJDUMP &> /dev/null; then
        echo ""
        echo -e "${YELLOW}Exported functions in $wasm_file:${NC}"
        $WASM_OBJDUMP -x "$OUTPUT_DIR/${wasm_file}.wasm" | grep -A 20 "Export section:" || true
    fi
}

# ============================================================================
# Build WASM Modules
# ============================================================================

echo "Building WASM modules..."
echo "-------------------------------------------"

# Build benchmark.wasm (pure WASM, no native calls)
compile_wasm "benchmark.c" "benchmark" ""
generate_header "benchmark" "benchmark_wasm"
inspect_wasm "benchmark"

echo ""

# Build native_calls.wasm (calls native functions)
compile_wasm "native_calls.c" "native_calls" ""
generate_header "native_calls" "native_calls_wasm"
inspect_wasm "native_calls"

echo ""
echo -e "${GREEN}===============================================${NC}"
echo -e "${GREEN}Build completed successfully!${NC}"
echo ""
echo "Generated files:"
echo "  - $OUTPUT_DIR/benchmark.wasm"
echo "  - $OUTPUT_DIR/native_calls.wasm"
echo "  - $HEADER_DIR/benchmark_wasm.h"
echo "  - $HEADER_DIR/native_calls_wasm.h"
echo ""
echo "Next steps:"
echo "  1. Include headers in your main.cpp"
echo "  2. Load WASM modules in setup()"
echo "  3. Call functions and benchmark!"
echo ""

# ============================================================================
# Generate text format for inspection (optional)
# ============================================================================

if command -v $WASM2WAT &> /dev/null; then
    echo -e "${YELLOW}Generating .wat files for inspection...${NC}"
    $WASM2WAT "$OUTPUT_DIR/benchmark.wasm" -o "$OUTPUT_DIR/benchmark.wat" 2>/dev/null || true
    $WASM2WAT "$OUTPUT_DIR/native_calls.wasm" -o "$OUTPUT_DIR/native_calls.wat" 2>/dev/null || true
    echo -e "${GREEN}✓ WAT files generated${NC}"
fi
