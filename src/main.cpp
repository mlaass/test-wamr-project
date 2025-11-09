#include <Arduino.h>
#include <WAMR.h>
#include <pthread.h>

// Simple WASM module that adds two numbers
// This is the compiled bytecode for: int add(int a, int b) { return a + b; }
// Generated from add.wat using wat2wasm and wasm_to_header.py
const unsigned char add_wasm[] = {
    0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x01, 0x07, 0x01,
    0x60, 0x02, 0x7f, 0x7f, 0x01, 0x7f, 0x03, 0x02, 0x01, 0x00, 0x07,
    0x07, 0x01, 0x03, 0x61, 0x64, 0x64, 0x00, 0x00, 0x0a, 0x09, 0x01,
    0x07, 0x00, 0x20, 0x00, 0x20, 0x01, 0x6a, 0x0b};
const unsigned int add_wasm_len = 41;

WamrModule module;

// Structure to pass data to the WASM execution thread
struct WasmCallData {
  WamrModule* module;
  const char* func_name;
  uint32_t argc;
  uint32_t* argv;
  bool success;
};

// Thread function that executes WASM in a pthread context
void* wasm_thread_func(void* arg) {
  WasmCallData* data = (WasmCallData*)arg;
  
  Serial.printf("WASM Thread: Calling function '%s'...\n", data->func_name);
  data->success = data->module->callFunction(data->func_name, data->argc, data->argv);
  
  if (!data->success) {
    Serial.println("WASM Thread: Function call failed");
    Serial.println(data->module->getError());
  } else {
    Serial.println("WASM Thread: Function call succeeded");
  }
  
  return nullptr;
}

// Helper function to call WASM function in a pthread
bool callWasmInThread(WamrModule* module, const char* func_name, uint32_t argc, uint32_t* argv) {
  WasmCallData data;
  data.module = module;
  data.func_name = func_name;
  data.argc = argc;
  data.argv = argv;
  data.success = false;
  
  pthread_t thread;
  pthread_attr_t attr;
  
  // Initialize thread attributes
  pthread_attr_init(&attr);
  pthread_attr_setstacksize(&attr, 32 * 1024); // 32KB stack
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
  
  // Create thread
  if (pthread_create(&thread, &attr, wasm_thread_func, &data) != 0) {
    Serial.println("ERROR: Failed to create pthread for WASM execution");
    pthread_attr_destroy(&attr);
    return false;
  }
  
  // Wait for thread to complete
  pthread_join(thread, nullptr);
  pthread_attr_destroy(&attr);
  
  return data.success;
}

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
  if (!callWasmInThread(&module, "add", 2, args)) {
    Serial.println("ERROR: Failed to call function!");
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
  Serial.println("loop");
}
