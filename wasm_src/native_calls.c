/**
 * native_calls.c - WASM functions that call native ESP32 functions
 *
 * This file demonstrates WASM calling native functions exported from
 * the ESP32 Arduino environment.
 */

// ============================================================================
// External Native Function Declarations
// ============================================================================

// These functions are implemented in ESP32 C++ and registered as native
// functions that WASM can call

// Arduino-style functions
extern void native_pin_mode(int pin, int mode);
extern void native_digital_write(int pin, int value);
extern int native_digital_read(int pin);
extern int native_analog_read(int pin);
extern unsigned int native_millis(void);
extern void native_delay(unsigned int ms);
extern void native_print_string(const char* str);
extern void native_print_int(int value);

// ============================================================================
// WASM Functions Using Native Calls
// ============================================================================

/**
 * Blink LED using native GPIO functions
 * Demonstrates WASM controlling hardware through native calls
 */
void blink_led(int pin, int times, int delay_ms) {
    // Set pin as OUTPUT (mode 1)
    native_pin_mode(pin, 1);

    for (int i = 0; i < times; i++) {
        native_digital_write(pin, 1);  // HIGH
        native_delay(delay_ms);
        native_digital_write(pin, 0);  // LOW
        native_delay(delay_ms);
    }
}

/**
 * Read analog value and categorize it
 * Tests native function calls with return values
 */
int read_sensor_category(int pin) {
    int value = native_analog_read(pin);

    if (value < 1024) return 0;      // Low
    else if (value < 2048) return 1; // Medium-Low
    else if (value < 3072) return 2; // Medium-High
    else return 3;                   // High
}

/**
 * Measure elapsed time using native millis()
 * Demonstrates timing operations from WASM
 */
unsigned int measure_elapsed(unsigned int start_time) {
    unsigned int current = native_millis();
    return current - start_time;
}

/**
 * Digital I/O test pattern
 * Write and read back to verify GPIO operation
 */
int gpio_test_pattern(int pin) {
    native_pin_mode(pin, 1);  // OUTPUT

    // Write HIGH and wait
    native_digital_write(pin, 1);
    native_delay(10);

    // Read back (switch to INPUT)
    native_pin_mode(pin, 0);  // INPUT
    int read_value = native_digital_read(pin);

    return read_value;
}

/**
 * Print benchmark results using native serial
 * Demonstrates string and integer printing
 */
void print_benchmark_result(const char* test_name, int result, unsigned int time_us) {
    native_print_string(test_name);
    native_print_string(": result=");
    native_print_int(result);
    native_print_string(" time=");
    native_print_int(time_us);
    native_print_string("us\n");
}

/**
 * Complex native interaction demo
 * Combines multiple native calls in sequence
 */
int complex_native_demo(int led_pin, int sensor_pin) {
    unsigned int start = native_millis();

    // Blink LED
    native_pin_mode(led_pin, 1);
    native_digital_write(led_pin, 1);
    native_delay(100);
    native_digital_write(led_pin, 0);

    // Read sensor
    int sensor_value = native_analog_read(sensor_pin);

    // Calculate elapsed time
    unsigned int elapsed = native_millis() - start;

    // Return combination of sensor value and time
    return (sensor_value % 1000) + elapsed;
}
