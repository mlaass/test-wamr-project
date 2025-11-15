(module $benchmark.wasm
  (type (;0;) (func))
  (type (;1;) (func (param i32) (result i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func (param i32 i32)))
  (type (;4;) (func (param i32 i32 i32)))
  (type (;5;) (func (param i32 i32 i32) (result i32)))
  (func $__wasm_call_ctors (type 0))
  (func $factorial_recursive (type 1) (param i32) (result i32)
    (local i32 i32 i32 i32 i32)
    i32.const 1
    local.set 1
    block  ;; label = @1
      local.get 0
      i32.const 2
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const -1
      i32.add
      local.tee 2
      i32.const 7
      i32.and
      local.set 3
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const -2
          i32.add
          i32.const 7
          i32.ge_u
          br_if 0 (;@3;)
          i32.const 1
          local.set 1
          br 1 (;@2;)
        end
        i32.const 0
        local.set 4
        i32.const 0
        local.get 2
        i32.const -8
        i32.and
        i32.sub
        local.set 5
        i32.const 1
        local.set 1
        loop  ;; label = @3
          local.get 0
          local.get 4
          i32.add
          local.tee 2
          i32.const -7
          i32.add
          local.get 2
          i32.const -6
          i32.add
          local.get 2
          i32.const -5
          i32.add
          local.get 2
          i32.const -4
          i32.add
          local.get 2
          i32.const -3
          i32.add
          local.get 2
          i32.const -2
          i32.add
          local.get 2
          i32.const -1
          i32.add
          local.get 2
          local.get 1
          i32.mul
          i32.mul
          i32.mul
          i32.mul
          i32.mul
          i32.mul
          i32.mul
          i32.mul
          local.set 1
          local.get 5
          local.get 4
          i32.const -8
          i32.add
          local.tee 4
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 0
        local.get 4
        i32.add
        local.set 0
      end
      local.get 3
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 0
        local.get 1
        i32.mul
        local.set 1
        local.get 0
        i32.const -1
        i32.add
        local.set 0
        local.get 3
        i32.const -1
        i32.add
        local.tee 3
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $factorial_iterative (type 1) (param i32) (result i32)
    (local i32 i32 i32)
    i32.const 2
    local.set 1
    i32.const 1
    local.set 2
    block  ;; label = @1
      local.get 0
      i32.const 2
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const -1
      i32.add
      local.tee 2
      i32.const 7
      i32.and
      local.set 3
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const -2
          i32.add
          i32.const 7
          i32.ge_u
          br_if 0 (;@3;)
          i32.const 1
          local.set 2
          br 1 (;@2;)
        end
        i32.const 0
        local.get 2
        i32.const -8
        i32.and
        i32.sub
        local.set 0
        i32.const 1
        local.set 2
        i32.const 9
        local.set 1
        loop  ;; label = @3
          local.get 1
          local.get 1
          i32.const -1
          i32.add
          local.get 1
          i32.const -2
          i32.add
          local.get 1
          i32.const -3
          i32.add
          local.get 1
          i32.const -4
          i32.add
          local.get 1
          i32.const -5
          i32.add
          local.get 1
          i32.const -6
          i32.add
          local.get 1
          i32.const -7
          i32.add
          local.get 2
          i32.mul
          i32.mul
          i32.mul
          i32.mul
          i32.mul
          i32.mul
          i32.mul
          i32.mul
          local.set 2
          local.get 0
          local.get 1
          i32.const 8
          i32.add
          local.tee 1
          i32.add
          i32.const 9
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 1
        i32.const -7
        i32.add
        local.set 1
      end
      local.get 3
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 1
        local.get 2
        i32.mul
        local.set 2
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        local.get 3
        i32.const -1
        i32.add
        local.tee 3
        br_if 0 (;@2;)
      end
    end
    local.get 2)
  (func $factorial_bench_1000 (type 1) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    i32.const 1
    local.set 1
    block  ;; label = @1
      local.get 0
      i32.const 2
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const -1
      i32.add
      local.tee 1
      i32.const 7
      i32.and
      local.set 2
      i32.const 0
      local.set 3
      i32.const 0
      local.get 1
      i32.const -8
      i32.and
      i32.sub
      local.set 4
      local.get 0
      i32.const -2
      i32.add
      i32.const 7
      i32.lt_u
      local.set 5
      loop  ;; label = @2
        i32.const 2
        local.set 0
        i32.const 1
        local.set 1
        block  ;; label = @3
          local.get 5
          br_if 0 (;@3;)
          i32.const 1
          local.set 1
          i32.const 9
          local.set 0
          loop  ;; label = @4
            local.get 1
            local.get 0
            i32.const -7
            i32.add
            i32.mul
            local.get 0
            i32.const -6
            i32.add
            i32.mul
            local.get 0
            i32.const -5
            i32.add
            i32.mul
            local.get 0
            i32.const -4
            i32.add
            i32.mul
            local.get 0
            i32.const -3
            i32.add
            i32.mul
            local.get 0
            i32.const -2
            i32.add
            i32.mul
            local.get 0
            i32.const -1
            i32.add
            i32.mul
            local.get 0
            i32.mul
            local.set 1
            local.get 4
            local.get 0
            i32.const 8
            i32.add
            local.tee 0
            i32.add
            i32.const 9
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 0
          i32.const -7
          i32.add
          local.set 0
        end
        block  ;; label = @3
          local.get 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 2
          local.set 6
          loop  ;; label = @4
            local.get 1
            local.get 0
            i32.mul
            local.set 1
            local.get 0
            i32.const 1
            i32.add
            local.set 0
            local.get 6
            i32.const -1
            i32.add
            local.tee 6
            br_if 0 (;@4;)
          end
        end
        local.get 3
        i32.const 1
        i32.add
        local.tee 3
        i32.const 1000
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $fibonacci_recursive (type 1) (param i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 2
      i32.ge_s
      br_if 0 (;@1;)
      local.get 0
      i32.const 0
      i32.add
      return
    end
    i32.const 0
    local.set 1
    loop  ;; label = @1
      local.get 0
      i32.const -1
      i32.add
      call $fibonacci_recursive
      local.get 1
      i32.add
      local.set 1
      local.get 0
      i32.const 3
      i32.gt_u
      local.set 2
      local.get 0
      i32.const -2
      i32.add
      local.tee 3
      local.set 0
      local.get 2
      br_if 0 (;@1;)
    end
    local.get 3
    local.get 1
    i32.add)
  (func $fibonacci_iterative (type 1) (param i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 2
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const -1
      i32.add
      local.tee 1
      i32.const 7
      i32.and
      local.set 2
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const -2
          i32.add
          i32.const 7
          i32.ge_u
          br_if 0 (;@3;)
          i32.const 0
          local.set 1
          i32.const 1
          local.set 0
          br 1 (;@2;)
        end
        local.get 1
        i32.const -8
        i32.and
        local.set 3
        i32.const 0
        local.set 1
        i32.const 1
        local.set 0
        loop  ;; label = @3
          local.get 0
          local.get 1
          i32.add
          local.tee 1
          local.get 0
          i32.add
          local.tee 0
          local.get 1
          i32.add
          local.tee 1
          local.get 0
          i32.add
          local.tee 0
          local.get 1
          i32.add
          local.tee 1
          local.get 0
          i32.add
          local.tee 0
          local.get 1
          i32.add
          local.tee 1
          local.get 0
          i32.add
          local.set 0
          local.get 3
          i32.const -8
          i32.add
          local.tee 3
          br_if 0 (;@3;)
        end
      end
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 0
        local.tee 3
        local.get 1
        i32.add
        local.set 0
        local.get 3
        local.set 1
        local.get 2
        i32.const -1
        i32.add
        local.tee 2
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func $fibonacci_bench_1000 (type 1) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 2
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const -1
      i32.add
      local.tee 1
      i32.const -8
      i32.and
      local.set 2
      local.get 1
      i32.const 7
      i32.and
      local.set 3
      i32.const 0
      local.set 4
      local.get 0
      i32.const -2
      i32.add
      i32.const 7
      i32.lt_u
      local.set 5
      loop  ;; label = @2
        i32.const 1
        local.set 0
        i32.const 0
        local.set 1
        block  ;; label = @3
          local.get 5
          br_if 0 (;@3;)
          i32.const 0
          local.set 1
          i32.const 1
          local.set 0
          local.get 2
          local.set 6
          loop  ;; label = @4
            local.get 0
            local.get 1
            local.get 0
            i32.add
            local.tee 1
            i32.add
            local.tee 0
            local.get 1
            local.get 0
            i32.add
            local.tee 0
            i32.add
            local.tee 1
            local.get 0
            local.get 1
            i32.add
            local.tee 0
            i32.add
            local.tee 1
            local.get 0
            local.get 1
            i32.add
            local.tee 1
            i32.add
            local.set 0
            local.get 6
            i32.const -8
            i32.add
            local.tee 6
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          local.get 3
          i32.eqz
          br_if 0 (;@3;)
          local.get 3
          local.set 6
          loop  ;; label = @4
            local.get 1
            local.get 0
            local.tee 7
            i32.add
            local.set 0
            local.get 7
            local.set 1
            local.get 6
            i32.const -1
            i32.add
            local.tee 6
            br_if 0 (;@4;)
          end
        end
        local.get 4
        i32.const 1
        i32.add
        local.tee 4
        i32.const 1000
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func $is_prime (type 1) (param i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 1
    block  ;; label = @1
      local.get 0
      i32.const 2
      i32.lt_s
      br_if 0 (;@1;)
      i32.const 1
      local.set 1
      local.get 0
      i32.const 2
      i32.eq
      br_if 0 (;@1;)
      i32.const 0
      local.set 1
      local.get 0
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      i32.const 1
      local.set 1
      local.get 0
      i32.const 9
      i32.lt_u
      br_if 0 (;@1;)
      i32.const 5
      local.set 1
      block  ;; label = @2
        loop  ;; label = @3
          local.get 0
          local.get 1
          i32.const -2
          i32.add
          i32.rem_u
          local.tee 2
          i32.eqz
          br_if 1 (;@2;)
          local.get 1
          local.get 1
          i32.mul
          local.set 3
          local.get 1
          i32.const 2
          i32.add
          local.set 1
          local.get 3
          local.get 0
          i32.le_s
          br_if 0 (;@3;)
        end
      end
      local.get 2
      i32.const 0
      i32.ne
      local.set 1
    end
    local.get 1)
  (func $count_primes (type 1) (param i32) (result i32)
    (local i32 i32 i32 i32)
    i32.const 0
    local.set 1
    block  ;; label = @1
      local.get 0
      i32.const 2
      i32.lt_s
      br_if 0 (;@1;)
      i32.const 0
      local.set 1
      i32.const 2
      local.set 2
      loop  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 2
            local.tee 3
            i32.const 2
            i32.eq
            br_if 0 (;@4;)
            local.get 3
            i32.const 1
            i32.and
            i32.eqz
            br_if 1 (;@3;)
            local.get 3
            i32.const 9
            i32.lt_u
            br_if 0 (;@4;)
            i32.const 5
            local.set 2
            loop  ;; label = @5
              local.get 3
              local.get 2
              i32.const -2
              i32.add
              i32.rem_u
              i32.eqz
              br_if 2 (;@3;)
              local.get 2
              local.get 2
              i32.mul
              local.set 4
              local.get 2
              i32.const 2
              i32.add
              local.set 2
              local.get 4
              local.get 3
              i32.le_u
              br_if 0 (;@5;)
            end
          end
          local.get 1
          i32.const 1
          i32.add
          local.set 1
        end
        local.get 3
        i32.const 1
        i32.add
        local.set 2
        local.get 3
        local.get 0
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $array_sum (type 2) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.const 1
      i32.ge_s
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    local.get 1
    i32.const 3
    i32.and
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.const 4
        i32.ge_u
        br_if 0 (;@2;)
        i32.const 0
        local.set 3
        i32.const 0
        local.set 4
        br 1 (;@1;)
      end
      local.get 1
      i32.const 2147483644
      i32.and
      local.set 5
      i32.const 0
      local.set 3
      local.get 0
      local.set 1
      i32.const 0
      local.set 4
      loop  ;; label = @2
        local.get 1
        i32.const 12
        i32.add
        i32.load
        local.get 1
        i32.const 8
        i32.add
        i32.load
        local.get 1
        i32.const 4
        i32.add
        i32.load
        local.get 1
        i32.load
        local.get 4
        i32.add
        i32.add
        i32.add
        i32.add
        local.set 4
        local.get 1
        i32.const 16
        i32.add
        local.set 1
        local.get 5
        local.get 3
        i32.const 4
        i32.add
        local.tee 3
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 3
      i32.const 2
      i32.shl
      i32.add
      local.set 1
      loop  ;; label = @2
        local.get 1
        i32.load
        local.get 4
        i32.add
        local.set 4
        local.get 1
        i32.const 4
        i32.add
        local.set 1
        local.get 2
        i32.const -1
        i32.add
        local.tee 2
        br_if 0 (;@2;)
      end
    end
    local.get 4)
  (func $array_sum_bench_1000 (type 2) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.const 1
      i32.ge_s
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    local.get 1
    i32.const 2147483644
    i32.and
    local.set 2
    local.get 1
    i32.const 3
    i32.and
    local.set 3
    i32.const 0
    local.set 4
    local.get 1
    i32.const 4
    i32.lt_u
    local.set 5
    loop  ;; label = @1
      i32.const 0
      local.set 6
      i32.const 0
      local.set 7
      block  ;; label = @2
        local.get 5
        br_if 0 (;@2;)
        i32.const 0
        local.set 6
        local.get 0
        local.set 1
        i32.const 0
        local.set 7
        loop  ;; label = @3
          local.get 1
          i32.const 12
          i32.add
          i32.load
          local.get 1
          i32.const 8
          i32.add
          i32.load
          local.get 1
          i32.const 4
          i32.add
          i32.load
          local.get 1
          i32.load
          local.get 7
          i32.add
          i32.add
          i32.add
          i32.add
          local.set 7
          local.get 1
          i32.const 16
          i32.add
          local.set 1
          local.get 2
          local.get 6
          i32.const 4
          i32.add
          local.tee 6
          i32.ne
          br_if 0 (;@3;)
        end
      end
      block  ;; label = @2
        local.get 3
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        local.get 6
        i32.const 2
        i32.shl
        i32.add
        local.set 1
        local.get 3
        local.set 6
        loop  ;; label = @3
          local.get 1
          i32.load
          local.get 7
          i32.add
          local.set 7
          local.get 1
          i32.const 4
          i32.add
          local.set 1
          local.get 6
          i32.const -1
          i32.add
          local.tee 6
          br_if 0 (;@3;)
        end
      end
      local.get 4
      i32.const 1
      i32.add
      local.tee 4
      i32.const 1000
      i32.ne
      br_if 0 (;@1;)
    end
    local.get 7)
  (func $array_max (type 2) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    local.get 0
    i32.load
    local.set 2
    block  ;; label = @1
      local.get 1
      i32.const 2
      i32.lt_s
      br_if 0 (;@1;)
      local.get 1
      i32.const -1
      i32.add
      local.tee 3
      i32.const 3
      i32.and
      local.set 4
      block  ;; label = @2
        block  ;; label = @3
          local.get 1
          i32.const -2
          i32.add
          i32.const 3
          i32.ge_u
          br_if 0 (;@3;)
          i32.const 1
          local.set 1
          br 1 (;@2;)
        end
        local.get 0
        i32.const 16
        i32.add
        local.set 1
        local.get 3
        i32.const -4
        i32.and
        local.set 5
        i32.const 0
        local.set 3
        loop  ;; label = @3
          local.get 1
          i32.load
          local.tee 6
          local.get 1
          i32.const -4
          i32.add
          i32.load
          local.tee 7
          local.get 1
          i32.const -8
          i32.add
          i32.load
          local.tee 8
          local.get 1
          i32.const -12
          i32.add
          i32.load
          local.tee 9
          local.get 2
          local.get 9
          local.get 2
          i32.gt_s
          select
          local.tee 2
          local.get 8
          local.get 2
          i32.gt_s
          select
          local.tee 2
          local.get 7
          local.get 2
          i32.gt_s
          select
          local.tee 2
          local.get 6
          local.get 2
          i32.gt_s
          select
          local.set 2
          local.get 1
          i32.const 16
          i32.add
          local.set 1
          local.get 5
          local.get 3
          i32.const 4
          i32.add
          local.tee 3
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 3
        i32.const 1
        i32.add
        local.set 1
      end
      local.get 4
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.const 2
      i32.shl
      i32.add
      local.set 1
      loop  ;; label = @2
        local.get 1
        i32.load
        local.tee 3
        local.get 2
        local.get 3
        local.get 2
        i32.gt_s
        select
        local.set 2
        local.get 1
        i32.const 4
        i32.add
        local.set 1
        local.get 4
        i32.const -1
        i32.add
        local.tee 4
        br_if 0 (;@2;)
      end
    end
    local.get 2)
  (func $array_reverse (type 3) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    local.get 1
    i32.const 2
    i32.div_s
    local.set 2
    block  ;; label = @1
      local.get 1
      i32.const 2
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.const 2
      i32.shl
      i32.add
      local.set 3
      local.get 2
      i32.const 1
      i32.and
      local.set 4
      i32.const 0
      local.set 5
      block  ;; label = @2
        local.get 1
        i32.const 2147483646
        i32.and
        i32.const 2
        i32.eq
        br_if 0 (;@2;)
        local.get 2
        i32.const 1073741822
        i32.and
        local.set 6
        local.get 1
        i32.const 2
        i32.shl
        local.get 0
        i32.add
        i32.const -4
        i32.add
        local.set 2
        i32.const 0
        local.set 5
        local.get 0
        local.set 1
        loop  ;; label = @3
          local.get 1
          i32.load
          local.set 7
          local.get 1
          local.get 2
          i32.load
          i32.store
          local.get 2
          local.get 7
          i32.store
          local.get 1
          i32.const 4
          i32.add
          local.tee 7
          i32.load
          local.set 8
          local.get 7
          local.get 3
          local.get 5
          i32.const 1073741822
          i32.xor
          i32.const 2
          i32.shl
          i32.add
          local.tee 9
          i32.load
          i32.store
          local.get 9
          local.get 8
          i32.store
          local.get 2
          i32.const -8
          i32.add
          local.set 2
          local.get 1
          i32.const 8
          i32.add
          local.set 1
          local.get 6
          local.get 5
          i32.const 2
          i32.add
          local.tee 5
          i32.ne
          br_if 0 (;@3;)
        end
      end
      local.get 4
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 5
      i32.const 2
      i32.shl
      i32.add
      local.tee 1
      i32.load
      local.set 2
      local.get 1
      local.get 3
      local.get 5
      i32.const -1
      i32.xor
      i32.const 2
      i32.shl
      i32.add
      local.tee 5
      i32.load
      i32.store
      local.get 5
      local.get 2
      i32.store
    end)
  (func $array_copy (type 4) (param i32 i32 i32)
    (local i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 2
      i32.const 1
      i32.lt_s
      br_if 0 (;@1;)
      local.get 2
      i32.const 3
      i32.and
      local.set 3
      i32.const 0
      local.set 4
      block  ;; label = @2
        local.get 2
        i32.const 4
        i32.lt_u
        br_if 0 (;@2;)
        local.get 2
        i32.const 2147483644
        i32.and
        local.set 5
        i32.const 0
        local.set 2
        i32.const 0
        local.set 4
        loop  ;; label = @3
          local.get 0
          local.get 2
          i32.add
          local.tee 6
          local.get 1
          local.get 2
          i32.add
          local.tee 7
          i32.load
          i32.store
          local.get 6
          i32.const 4
          i32.add
          local.get 7
          i32.const 4
          i32.add
          i32.load
          i32.store
          local.get 6
          i32.const 8
          i32.add
          local.get 7
          i32.const 8
          i32.add
          i32.load
          i32.store
          local.get 6
          i32.const 12
          i32.add
          local.get 7
          i32.const 12
          i32.add
          i32.load
          i32.store
          local.get 2
          i32.const 16
          i32.add
          local.set 2
          local.get 5
          local.get 4
          i32.const 4
          i32.add
          local.tee 4
          i32.ne
          br_if 0 (;@3;)
        end
      end
      local.get 3
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      local.get 4
      i32.const 2
      i32.shl
      local.tee 6
      i32.add
      local.set 2
      local.get 0
      local.get 6
      i32.add
      local.set 6
      loop  ;; label = @2
        local.get 6
        local.get 2
        i32.load
        i32.store
        local.get 2
        i32.const 4
        i32.add
        local.set 2
        local.get 6
        i32.const 4
        i32.add
        local.set 6
        local.get 3
        i32.const -1
        i32.add
        local.tee 3
        br_if 0 (;@2;)
      end
    end)
  (func $bubble_sort (type 3) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.const 2
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const 4
      i32.add
      local.set 2
      local.get 1
      i32.const -2
      i32.add
      local.set 3
      i32.const 0
      local.set 4
      local.get 1
      i32.const -1
      i32.add
      local.tee 5
      local.set 6
      loop  ;; label = @2
        block  ;; label = @3
          local.get 4
          local.get 1
          i32.sub
          i32.const -2
          i32.gt_s
          br_if 0 (;@3;)
          local.get 0
          i32.load
          local.set 7
          i32.const 0
          local.set 8
          block  ;; label = @4
            local.get 3
            local.get 4
            i32.eq
            br_if 0 (;@4;)
            local.get 6
            i32.const -2
            i32.and
            local.set 9
            i32.const 0
            local.set 8
            local.get 0
            local.set 10
            loop  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 7
                  local.get 10
                  i32.const 4
                  i32.add
                  local.tee 11
                  i32.load
                  local.tee 12
                  i32.gt_s
                  br_if 0 (;@7;)
                  local.get 12
                  local.set 7
                  br 1 (;@6;)
                end
                local.get 10
                local.get 12
                i32.store
                local.get 11
                local.get 7
                i32.store
              end
              block  ;; label = @6
                block  ;; label = @7
                  local.get 7
                  local.get 10
                  i32.const 8
                  i32.add
                  local.tee 12
                  i32.load
                  local.tee 13
                  i32.gt_s
                  br_if 0 (;@7;)
                  local.get 13
                  local.set 7
                  br 1 (;@6;)
                end
                local.get 10
                i32.const 8
                i32.add
                local.get 7
                i32.store
                local.get 11
                local.get 13
                i32.store
              end
              local.get 12
              local.set 10
              local.get 9
              local.get 8
              i32.const 2
              i32.add
              local.tee 8
              i32.ne
              br_if 0 (;@5;)
            end
          end
          local.get 6
          i32.const 1
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          local.get 7
          local.get 2
          local.get 8
          i32.const 2
          i32.shl
          local.tee 10
          i32.add
          local.tee 8
          i32.load
          local.tee 11
          i32.le_s
          br_if 0 (;@3;)
          local.get 8
          local.get 7
          i32.store
          local.get 0
          local.get 10
          i32.add
          local.get 11
          i32.store
        end
        local.get 6
        i32.const -1
        i32.add
        local.set 6
        local.get 4
        i32.const 1
        i32.add
        local.tee 4
        local.get 5
        i32.ne
        br_if 0 (;@2;)
      end
    end)
  (func $binary_search (type 5) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.const 1
      i32.ge_s
      br_if 0 (;@1;)
      i32.const -1
      return
    end
    local.get 1
    i32.const -1
    i32.add
    local.set 3
    i32.const 0
    local.set 1
    loop  ;; label = @1
      block  ;; label = @2
        local.get 0
        local.get 3
        local.get 1
        i32.sub
        i32.const 2
        i32.div_s
        local.get 1
        i32.add
        local.tee 4
        i32.const 2
        i32.shl
        i32.add
        i32.load
        local.tee 5
        local.get 2
        i32.ne
        br_if 0 (;@2;)
        local.get 4
        return
      end
      local.get 4
      i32.const 1
      i32.add
      local.get 1
      local.get 5
      local.get 2
      i32.lt_s
      local.tee 5
      select
      local.tee 1
      local.get 3
      local.get 4
      i32.const -1
      i32.add
      local.get 5
      select
      local.tee 3
      i32.le_s
      br_if 0 (;@1;)
    end
    i32.const -1)
  (func $complex_workload (type 2) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    i32.const 1
    local.set 2
    i32.const 2
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 1
        i32.const 3
        i32.and
        local.set 4
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            i32.const 4
            i32.ge_u
            br_if 0 (;@4;)
            i32.const 0
            local.set 5
            i32.const 0
            local.set 6
            br 1 (;@3;)
          end
          local.get 1
          i32.const 2147483644
          i32.and
          local.set 7
          i32.const 0
          local.set 5
          local.get 0
          local.set 8
          i32.const 0
          local.set 6
          loop  ;; label = @4
            local.get 8
            i32.const 12
            i32.add
            i32.load
            local.get 8
            i32.const 8
            i32.add
            i32.load
            local.get 8
            i32.const 4
            i32.add
            i32.load
            local.get 8
            i32.load
            local.get 5
            i32.add
            i32.add
            i32.add
            i32.add
            local.set 5
            local.get 8
            i32.const 16
            i32.add
            local.set 8
            local.get 7
            local.get 6
            i32.const 4
            i32.add
            local.tee 6
            i32.ne
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          local.get 4
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          local.get 6
          i32.const 2
          i32.shl
          i32.add
          local.set 8
          loop  ;; label = @4
            local.get 8
            i32.load
            local.get 5
            i32.add
            local.set 5
            local.get 8
            i32.const 4
            i32.add
            local.set 8
            local.get 4
            i32.const -1
            i32.add
            local.tee 4
            br_if 0 (;@4;)
          end
        end
        i32.const 1
        local.set 4
        local.get 5
        i32.const 10
        i32.rem_s
        local.tee 8
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 8
        i32.const 7
        i32.and
        local.set 5
        block  ;; label = @3
          block  ;; label = @4
            local.get 8
            i32.const 8
            i32.ge_u
            br_if 0 (;@4;)
            i32.const 2
            local.set 8
            br 1 (;@3;)
          end
          i32.const 0
          local.get 8
          i32.const 2147483640
          i32.and
          i32.sub
          local.set 6
          i32.const 1
          local.set 4
          i32.const 9
          local.set 8
          loop  ;; label = @4
            local.get 4
            local.get 8
            i32.const -7
            i32.add
            i32.mul
            local.get 8
            i32.const -6
            i32.add
            i32.mul
            local.get 8
            i32.const -5
            i32.add
            i32.mul
            local.get 8
            i32.const -4
            i32.add
            i32.mul
            local.get 8
            i32.const -3
            i32.add
            i32.mul
            local.get 8
            i32.const -2
            i32.add
            i32.mul
            local.get 8
            i32.const -1
            i32.add
            i32.mul
            local.get 8
            i32.mul
            local.set 4
            local.get 6
            local.get 8
            i32.const 8
            i32.add
            local.tee 8
            i32.add
            i32.const 9
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 8
          i32.const -7
          i32.add
          local.set 8
        end
        block  ;; label = @3
          local.get 5
          i32.eqz
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 4
            local.get 8
            i32.mul
            local.set 4
            local.get 8
            i32.const 1
            i32.add
            local.set 8
            local.get 5
            i32.const -1
            i32.add
            local.tee 5
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          local.get 4
          i32.const 15
          i32.rem_u
          local.tee 8
          br_if 0 (;@3;)
          i32.const 1
          local.set 2
          br 2 (;@1;)
        end
        local.get 8
        i32.const 1
        i32.add
        local.set 3
      end
      local.get 3
      i32.const -1
      i32.add
      local.tee 8
      i32.const 7
      i32.and
      local.set 5
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i32.const -2
          i32.add
          i32.const 7
          i32.ge_u
          br_if 0 (;@3;)
          i32.const 0
          local.set 8
          br 1 (;@2;)
        end
        local.get 8
        i32.const -8
        i32.and
        local.set 4
        i32.const 0
        local.set 8
        i32.const 1
        local.set 2
        loop  ;; label = @3
          local.get 2
          local.get 8
          local.get 2
          i32.add
          local.tee 8
          i32.add
          local.tee 2
          local.get 8
          local.get 2
          i32.add
          local.tee 2
          i32.add
          local.tee 8
          local.get 2
          local.get 8
          i32.add
          local.tee 2
          i32.add
          local.tee 8
          local.get 2
          local.get 8
          i32.add
          local.tee 8
          i32.add
          local.set 2
          local.get 4
          i32.const -8
          i32.add
          local.tee 4
          br_if 0 (;@3;)
        end
      end
      local.get 5
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 8
        local.get 2
        local.tee 4
        i32.add
        local.set 2
        local.get 4
        local.set 8
        local.get 5
        i32.const -1
        i32.add
        local.tee 5
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        br_if 0 (;@2;)
        i32.const 0
        local.set 8
        br 1 (;@1;)
      end
      local.get 0
      i32.load
      local.set 8
      local.get 1
      i32.const 2
      i32.lt_s
      br_if 0 (;@1;)
      local.get 1
      i32.const -1
      i32.add
      local.tee 6
      i32.const 3
      i32.and
      local.set 4
      block  ;; label = @2
        block  ;; label = @3
          local.get 1
          i32.const -2
          i32.add
          i32.const 3
          i32.ge_u
          br_if 0 (;@3;)
          i32.const 1
          local.set 5
          br 1 (;@2;)
        end
        local.get 0
        i32.const 16
        i32.add
        local.set 5
        local.get 6
        i32.const -4
        i32.and
        local.set 9
        i32.const 0
        local.set 6
        loop  ;; label = @3
          local.get 5
          i32.load
          local.tee 7
          local.get 5
          i32.const -4
          i32.add
          i32.load
          local.tee 1
          local.get 5
          i32.const -8
          i32.add
          i32.load
          local.tee 3
          local.get 5
          i32.const -12
          i32.add
          i32.load
          local.tee 10
          local.get 8
          local.get 10
          local.get 8
          i32.gt_s
          select
          local.tee 8
          local.get 3
          local.get 8
          i32.gt_s
          select
          local.tee 8
          local.get 1
          local.get 8
          i32.gt_s
          select
          local.tee 8
          local.get 7
          local.get 8
          i32.gt_s
          select
          local.set 8
          local.get 5
          i32.const 16
          i32.add
          local.set 5
          local.get 9
          local.get 6
          i32.const 4
          i32.add
          local.tee 6
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 6
        i32.const 1
        i32.add
        local.set 5
      end
      local.get 4
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 5
      i32.const 2
      i32.shl
      i32.add
      local.set 5
      loop  ;; label = @2
        local.get 5
        i32.load
        local.tee 6
        local.get 8
        local.get 6
        local.get 8
        i32.gt_s
        select
        local.set 8
        local.get 5
        i32.const 4
        i32.add
        local.set 5
        local.get 4
        i32.const -1
        i32.add
        local.tee 4
        br_if 0 (;@2;)
      end
    end
    local.get 8
    local.get 2
    i32.add
    i32.const 1000
    i32.rem_s)
  (func $matrix_multiply_4x4 (type 4) (param i32 i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    local.get 2
    i32.const 32
    i32.add
    local.set 3
    local.get 2
    i32.const 48
    i32.add
    local.set 4
    local.get 2
    i32.const 20
    i32.add
    local.set 5
    local.get 2
    i32.const 36
    i32.add
    local.set 6
    local.get 2
    i32.const 52
    i32.add
    local.set 7
    local.get 2
    i32.const 24
    i32.add
    local.set 8
    local.get 2
    i32.const 40
    i32.add
    local.set 9
    local.get 2
    i32.const 56
    i32.add
    local.set 10
    local.get 2
    i32.const 28
    i32.add
    local.set 11
    local.get 2
    i32.const 44
    i32.add
    local.set 12
    local.get 2
    i32.const 60
    i32.add
    local.set 13
    i32.const 0
    local.set 14
    loop  ;; label = @1
      local.get 0
      local.get 14
      i32.add
      local.tee 15
      i32.const 0
      i32.store
      local.get 15
      local.get 2
      i32.load
      local.get 1
      local.get 14
      i32.add
      local.tee 16
      i32.load
      i32.mul
      local.tee 17
      i32.store
      local.get 15
      local.get 17
      local.get 2
      i32.const 16
      i32.add
      i32.load
      local.get 16
      i32.const 4
      i32.add
      local.tee 18
      i32.load
      i32.mul
      i32.add
      local.tee 17
      i32.store
      local.get 15
      local.get 17
      local.get 3
      i32.load
      local.get 16
      i32.const 8
      i32.add
      local.tee 19
      i32.load
      i32.mul
      i32.add
      local.tee 20
      i32.store
      local.get 4
      i32.load
      local.set 21
      local.get 16
      i32.const 12
      i32.add
      local.tee 22
      i32.load
      local.set 23
      local.get 15
      i32.const 4
      i32.add
      local.tee 17
      i32.const 0
      i32.store
      local.get 15
      local.get 20
      local.get 21
      local.get 23
      i32.mul
      i32.add
      i32.store
      local.get 17
      local.get 2
      i32.const 4
      i32.add
      i32.load
      local.get 16
      i32.load
      i32.mul
      local.tee 20
      i32.store
      local.get 17
      local.get 20
      local.get 5
      i32.load
      local.get 18
      i32.load
      i32.mul
      i32.add
      local.tee 20
      i32.store
      local.get 17
      local.get 20
      local.get 6
      i32.load
      local.get 19
      i32.load
      i32.mul
      i32.add
      local.tee 21
      i32.store
      local.get 7
      i32.load
      local.set 23
      local.get 22
      i32.load
      local.set 24
      local.get 15
      i32.const 8
      i32.add
      local.tee 20
      i32.const 0
      i32.store
      local.get 17
      local.get 21
      local.get 23
      local.get 24
      i32.mul
      i32.add
      i32.store
      local.get 20
      local.get 2
      i32.const 8
      i32.add
      i32.load
      local.get 16
      i32.load
      i32.mul
      local.tee 17
      i32.store
      local.get 20
      local.get 17
      local.get 8
      i32.load
      local.get 18
      i32.load
      i32.mul
      i32.add
      local.tee 17
      i32.store
      local.get 20
      local.get 17
      local.get 9
      i32.load
      local.get 19
      i32.load
      i32.mul
      i32.add
      local.tee 17
      i32.store
      local.get 10
      i32.load
      local.set 21
      local.get 22
      i32.load
      local.set 23
      local.get 15
      i32.const 12
      i32.add
      local.tee 15
      i32.const 0
      i32.store
      local.get 20
      local.get 17
      local.get 21
      local.get 23
      i32.mul
      i32.add
      i32.store
      local.get 15
      local.get 2
      i32.const 12
      i32.add
      i32.load
      local.get 16
      i32.load
      i32.mul
      local.tee 16
      i32.store
      local.get 15
      local.get 16
      local.get 11
      i32.load
      local.get 18
      i32.load
      i32.mul
      i32.add
      local.tee 16
      i32.store
      local.get 15
      local.get 16
      local.get 12
      i32.load
      local.get 19
      i32.load
      i32.mul
      i32.add
      local.tee 16
      i32.store
      local.get 15
      local.get 16
      local.get 13
      i32.load
      local.get 22
      i32.load
      i32.mul
      i32.add
      i32.store
      local.get 14
      i32.const 16
      i32.add
      local.tee 14
      i32.const 64
      i32.ne
      br_if 0 (;@1;)
    end)
  (func $checksum (type 2) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.const 1
      i32.ge_s
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    local.get 1
    i32.const 3
    i32.and
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.const 4
        i32.ge_u
        br_if 0 (;@2;)
        i32.const 0
        local.set 3
        i32.const 0
        local.set 4
        br 1 (;@1;)
      end
      local.get 1
      i32.const 2147483644
      i32.and
      local.set 5
      i32.const 0
      local.set 3
      local.get 0
      local.set 1
      i32.const 0
      local.set 4
      loop  ;; label = @2
        local.get 1
        i32.const 12
        i32.add
        i32.load
        local.get 1
        i32.const 8
        i32.add
        i32.load
        local.get 1
        i32.const 4
        i32.add
        i32.load
        local.get 1
        i32.load
        local.get 4
        i32.xor
        local.tee 4
        i32.const 1
        i32.shl
        local.get 4
        i32.const 31
        i32.shr_s
        i32.or
        i32.xor
        local.tee 4
        i32.const 1
        i32.shl
        local.get 4
        i32.const 31
        i32.shr_s
        i32.or
        i32.xor
        local.tee 4
        i32.const 1
        i32.shl
        local.get 4
        i32.const 31
        i32.shr_s
        i32.or
        i32.xor
        local.tee 4
        i32.const 1
        i32.shl
        local.get 4
        i32.const 31
        i32.shr_s
        i32.or
        local.set 4
        local.get 1
        i32.const 16
        i32.add
        local.set 1
        local.get 5
        local.get 3
        i32.const 4
        i32.add
        local.tee 3
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 3
      i32.const 2
      i32.shl
      i32.add
      local.set 1
      loop  ;; label = @2
        local.get 1
        i32.load
        local.get 4
        i32.xor
        local.tee 4
        i32.const 1
        i32.shl
        local.get 4
        i32.const 31
        i32.shr_s
        i32.or
        local.set 4
        local.get 1
        i32.const 4
        i32.add
        local.set 1
        local.get 2
        i32.const -1
        i32.add
        local.tee 2
        br_if 0 (;@2;)
      end
    end
    local.get 4)
  (memory (;0;) 2)
  (global $__stack_pointer (mut i32) (i32.const 66560))
  (global (;1;) i32 (i32.const 1024))
  (global (;2;) i32 (i32.const 1024))
  (global (;3;) i32 (i32.const 1024))
  (global (;4;) i32 (i32.const 66560))
  (global (;5;) i32 (i32.const 1024))
  (global (;6;) i32 (i32.const 66560))
  (global (;7;) i32 (i32.const 131072))
  (global (;8;) i32 (i32.const 0))
  (global (;9;) i32 (i32.const 1))
  (export "memory" (memory 0))
  (export "__wasm_call_ctors" (func $__wasm_call_ctors))
  (export "factorial_recursive" (func $factorial_recursive))
  (export "factorial_iterative" (func $factorial_iterative))
  (export "factorial_bench_1000" (func $factorial_bench_1000))
  (export "fibonacci_recursive" (func $fibonacci_recursive))
  (export "fibonacci_iterative" (func $fibonacci_iterative))
  (export "fibonacci_bench_1000" (func $fibonacci_bench_1000))
  (export "is_prime" (func $is_prime))
  (export "count_primes" (func $count_primes))
  (export "array_sum" (func $array_sum))
  (export "array_sum_bench_1000" (func $array_sum_bench_1000))
  (export "array_max" (func $array_max))
  (export "array_reverse" (func $array_reverse))
  (export "array_copy" (func $array_copy))
  (export "bubble_sort" (func $bubble_sort))
  (export "binary_search" (func $binary_search))
  (export "complex_workload" (func $complex_workload))
  (export "matrix_multiply_4x4" (func $matrix_multiply_4x4))
  (export "checksum" (func $checksum))
  (export "__dso_handle" (global 1))
  (export "__data_end" (global 2))
  (export "__stack_low" (global 3))
  (export "__stack_high" (global 4))
  (export "__global_base" (global 5))
  (export "__heap_base" (global 6))
  (export "__heap_end" (global 7))
  (export "__memory_base" (global 8))
  (export "__table_base" (global 9)))
