(module $native_calls.wasm
  (type (;0;) (func (param i32 i32)))
  (type (;1;) (func (param i32)))
  (type (;2;) (func (param i32) (result i32)))
  (type (;3;) (func (result i32)))
  (type (;4;) (func))
  (type (;5;) (func (param i32 i32 i32)))
  (type (;6;) (func (param i32 i32) (result i32)))
  (import "env" "native_pin_mode" (func $native_pin_mode (type 0)))
  (import "env" "native_digital_write" (func $native_digital_write (type 0)))
  (import "env" "native_delay" (func $native_delay (type 1)))
  (import "env" "native_analog_read" (func $native_analog_read (type 2)))
  (import "env" "native_millis" (func $native_millis (type 3)))
  (import "env" "native_digital_read" (func $native_digital_read (type 2)))
  (import "env" "native_print_string" (func $native_print_string (type 1)))
  (import "env" "native_print_int" (func $native_print_int (type 1)))
  (func $__wasm_call_ctors (type 4))
  (func $blink_led (type 5) (param i32 i32 i32)
    local.get 0
    i32.const 1
    call $native_pin_mode
    block  ;; label = @1
      local.get 1
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 0
        i32.const 1
        call $native_digital_write
        local.get 2
        call $native_delay
        local.get 0
        i32.const 0
        call $native_digital_write
        local.get 2
        call $native_delay
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        br_if 0 (;@2;)
      end
    end)
  (func $read_sensor_category (type 2) (param i32) (result i32)
    (local i32)
    i32.const 0
    local.set 1
    block  ;; label = @1
      local.get 0
      call $native_analog_read
      local.tee 0
      i32.const 1024
      i32.lt_s
      br_if 0 (;@1;)
      i32.const 1
      local.set 1
      local.get 0
      i32.const 2048
      i32.lt_u
      br_if 0 (;@1;)
      i32.const 2
      i32.const 3
      local.get 0
      i32.const 3072
      i32.lt_u
      select
      local.set 1
    end
    local.get 1)
  (func $measure_elapsed (type 2) (param i32) (result i32)
    call $native_millis
    local.get 0
    i32.sub)
  (func $gpio_test_pattern (type 2) (param i32) (result i32)
    local.get 0
    i32.const 1
    call $native_pin_mode
    local.get 0
    i32.const 1
    call $native_digital_write
    i32.const 10
    call $native_delay
    local.get 0
    i32.const 0
    call $native_pin_mode
    local.get 0
    call $native_digital_read)
  (func $print_benchmark_result (type 5) (param i32 i32 i32)
    local.get 0
    call $native_print_string
    i32.const 1024
    call $native_print_string
    local.get 1
    call $native_print_int
    i32.const 1034
    call $native_print_string
    local.get 2
    call $native_print_int
    i32.const 1041
    call $native_print_string)
  (func $complex_native_demo (type 6) (param i32 i32) (result i32)
    (local i32)
    call $native_millis
    local.set 2
    local.get 0
    i32.const 1
    call $native_pin_mode
    local.get 0
    i32.const 1
    call $native_digital_write
    i32.const 100
    call $native_delay
    local.get 0
    i32.const 0
    call $native_digital_write
    local.get 1
    call $native_analog_read
    local.set 0
    call $native_millis
    local.get 2
    i32.sub
    local.get 0
    i32.const 1000
    i32.rem_s
    i32.add)
  (memory (;0;) 2)
  (global $__stack_pointer (mut i32) (i32.const 66592))
  (global (;1;) i32 (i32.const 1024))
  (global (;2;) i32 (i32.const 1045))
  (global (;3;) i32 (i32.const 1056))
  (global (;4;) i32 (i32.const 66592))
  (global (;5;) i32 (i32.const 1024))
  (global (;6;) i32 (i32.const 66592))
  (global (;7;) i32 (i32.const 131072))
  (global (;8;) i32 (i32.const 0))
  (global (;9;) i32 (i32.const 1))
  (export "memory" (memory 0))
  (export "__wasm_call_ctors" (func $__wasm_call_ctors))
  (export "blink_led" (func $blink_led))
  (export "read_sensor_category" (func $read_sensor_category))
  (export "measure_elapsed" (func $measure_elapsed))
  (export "gpio_test_pattern" (func $gpio_test_pattern))
  (export "print_benchmark_result" (func $print_benchmark_result))
  (export "complex_native_demo" (func $complex_native_demo))
  (export "__dso_handle" (global 1))
  (export "__data_end" (global 2))
  (export "__stack_low" (global 3))
  (export "__stack_high" (global 4))
  (export "__global_base" (global 5))
  (export "__heap_base" (global 6))
  (export "__heap_end" (global 7))
  (export "__memory_base" (global 8))
  (export "__table_base" (global 9))
  (data $.rodata (i32.const 1024) ": result=\00 time=\00us\0a\00"))
