#include <Arduino.h>
#include <WAMR.h>

// Simple WASM module that adds two numbers
// This is the compiled bytecode for: int add(int a, int b) { return a + b; }
// Generated from add.wat using wat2wasm and wasm_to_header.py
const unsigned char add_wasm[] = {
    0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x01, 0x07, 0x01, 0x60,
    0x02, 0x7f, 0x7f, 0x01, 0x7f, 0x03, 0x02, 0x01, 0x00, 0x07, 0x07, 0x01,
    0x03, 0x61, 0x64, 0x64, 0x00, 0x00, 0x0a, 0x09, 0x01, 0x07, 0x00, 0x20,
    0x00, 0x20, 0x01, 0x6a, 0x0b};
const unsigned int add_wasm_len = 41;

WamrModule module;

void setup() {
  Serial.begin(115200);
  delay(5000);

  Serial.println("\n=== WAMR ESP32 Test ===");
  delay(1000);
  // Initialize WAMR runtime with 128KB heap
  Serial.println("Initializing WAMR runtime...");
  if (!WamrRuntime::begin(128 * 1024)) {
    Serial.println("ERROR: Failed to initialize WAMR runtime!");
    Serial.println(WamrRuntime::getError());
    return;
  }
  Serial.println("WAMR runtime initialized successfully");

  // Load the WASM module
  Serial.println("\nLoading WASM module...");
  if (!module.load(add_wasm, add_wasm_len, 16 * 1024, 32 * 1024)) {
    Serial.println("ERROR: Failed to load WASM module!");
    Serial.println(module.getError());
    return;
  }
  Serial.println("WASM module loaded successfully");

  // Call the add function with arguments 42 and 58
  Serial.println("\nCalling WASM function add(42, 58)...");
  uint32_t args[2] = {42, 58};
  if (!module.callFunction("add", 2, args)) {
    Serial.println("ERROR: Failed to call function!");
    Serial.println(module.getError());
    return;
  }

  // Get the result (stored in args[0])
  uint32_t result = args[0];
  Serial.printf("Result: %u\n", result);
  Serial.printf("Expected: 100\n");

  if (result == 100) {
    Serial.println("\n✓ Test PASSED!");
  } else {
    Serial.println("\n✗ Test FAILED!");
  }

  // Print memory usage
  Serial.println("\nMemory usage:");
  WamrRuntime::printMemoryUsage();
}

void loop() {
  // Nothing to do in loop
  delay(5000);
  // Call the add function with arguments 42 and 58
  Serial.println("\nCalling WASM function add(42, 58)...");
  uint32_t args[2] = {42, 58};
  if (!module.callFunction("add", 2, args)) {
    Serial.println("ERROR: Failed to call function!");
    Serial.println(module.getError());
    return;
  }

  // Get the result (stored in args[0])
  uint32_t result = args[0];
  Serial.printf("Result: %u\n", result);
  Serial.printf("Expected: 100\n");

  if (result == 100) {
    Serial.println("\n✓ Test PASSED!");
  } else {
    Serial.println("\n✗ Test FAILED!");
  }
  WamrRuntime::printMemoryUsage();
}
