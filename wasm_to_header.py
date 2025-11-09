#!/usr/bin/env python3
"""
Convert a WASM file to a C/C++ header file with byte array.
Usage: python3 wasm_to_header.py input.wasm [output.h]
"""

import sys
import os

def wasm_to_header(wasm_file, header_file=None):
    """Convert WASM file to C header with byte array."""
    
    # Read the WASM file
    with open(wasm_file, 'rb') as f:
        wasm_bytes = f.read()
    
    # Generate output filename if not provided
    if header_file is None:
        base_name = os.path.splitext(os.path.basename(wasm_file))[0]
        header_file = f"{base_name}.h"
    
    # Generate the array name from filename
    array_name = os.path.splitext(os.path.basename(wasm_file))[0].replace('-', '_').replace('.', '_')
    
    # Generate header content
    header_content = f"""// Auto-generated from {os.path.basename(wasm_file)}
// WASM module size: {len(wasm_bytes)} bytes

#ifndef {array_name.upper()}_H
#define {array_name.upper()}_H

const unsigned char {array_name}_wasm[] = {{
"""
    
    # Add bytes in rows of 12
    for i in range(0, len(wasm_bytes), 12):
        chunk = wasm_bytes[i:i+12]
        hex_bytes = ', '.join(f'0x{b:02x}' for b in chunk)
        header_content += f"    {hex_bytes}"
        if i + 12 < len(wasm_bytes):
            header_content += ","
        header_content += "\n"
    
    header_content += f"""}};
const unsigned int {array_name}_wasm_len = {len(wasm_bytes)};

#endif // {array_name.upper()}_H
"""
    
    # Write the header file
    with open(header_file, 'w') as f:
        f.write(header_content)
    
    print(f"✓ Converted {wasm_file} ({len(wasm_bytes)} bytes) -> {header_file}")
    print(f"  Array name: {array_name}_wasm")
    print(f"  Length var: {array_name}_wasm_len")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 wasm_to_header.py input.wasm [output.h]")
        sys.exit(1)
    
    wasm_file = sys.argv[1]
    header_file = sys.argv[2] if len(sys.argv) > 2 else None
    
    if not os.path.exists(wasm_file):
        print(f"Error: File '{wasm_file}' not found")
        sys.exit(1)
    
    wasm_to_header(wasm_file, header_file)
