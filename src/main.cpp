#include <Arduino.h>
#include <WAMR.h>

// Simple WASM module that adds two numbers
#include "add.h"

WamrModule module;

void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println("\n========================================");
  Serial.println("  WAMR ESP32 Integration Test");
  Serial.println("========================================\n");

  // Initialize WAMR runtime with 128KB heap
  Serial.println("Step 1: Initializing WAMR runtime...");
  if (!WamrRuntime::begin(128 * 1024)) {
    Serial.println("ERROR: Failed to initialize WAMR runtime!");
    Serial.println(WamrRuntime::getError());
    while (1)
      delay(1000);
  }
  Serial.println("✓ WAMR runtime initialized\n");

  // Load the WASM module
  Serial.println("Step 2: Loading WASM module...");
  if (!module.load(add_wasm, add_wasm_len, 16 * 1024, 32 * 1024)) {
    Serial.println("ERROR: Failed to load WASM module!");
    Serial.println(module.getError());
    while (1)
      delay(1000);
  }
  Serial.println("✓ WASM module loaded\n");

  // Test 1: Call using SAFE API (recommended)
  Serial.println("========================================");
  Serial.println("Test 1: Safe API (callFunction)");
  Serial.println("========================================");
  Serial.println("This automatically wraps the call in pthread context.\n");

  uint32_t args[2] = {42, 58};
  Serial.println("Calling add(42, 58) using callFunction()...");

  if (!module.callFunction("add", 2, args)) {
    Serial.println("ERROR: Function call failed!");
    Serial.println(module.getError());
    while (1)
      delay(1000);
  }

  uint32_t result = args[0];
  Serial.printf("Result: %u\n", result);
  Serial.printf("Expected: 100\n");

  if (result == 100) {
    Serial.println("✓ Test PASSED!\n");
  } else {
    Serial.println("✗ Test FAILED!\n");
    while (1)
      delay(1000);
  }

  // Test 2: Multiple calls
  Serial.println("========================================");
  Serial.println("Test 2: Multiple Function Calls");
  Serial.println("========================================\n");

  struct TestCase {
    int a, b, expected;
  } tests[] = {{10, 20, 30}, {100, 200, 300}, {999, 1, 1000}};

  for (int i = 0; i < 3; i++) {
    args[0] = tests[i].a;
    args[1] = tests[i].b;

    if (module.callFunction("add", 2, args)) {
      uint32_t res = args[0];
      bool passed = (int32_t)res == tests[i].expected;
      Serial.printf("  add(%d, %d) = %d %s\n", tests[i].a, tests[i].b,
                    (int32_t)res, passed ? "✓" : "✗");
    }
  }

  Serial.println("\n========================================");
  Serial.println("  All Tests Complete!");
  Serial.println("========================================\n");

  // Print memory usage
  WamrRuntime::printMemoryUsage();
  Serial.println();
}

void loop() {
  // Nothing to do in loop
  delay(10000);
}
