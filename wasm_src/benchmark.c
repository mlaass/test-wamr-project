/**
 * benchmark.c - Comprehensive WASM benchmark functions
 *
 * This file contains various computational and memory operations
 * designed to benchmark WASM performance compared to native C++.
 */

// ============================================================================
// Mathematical Functions
// ============================================================================

/**
 * Calculate factorial recursively
 * Good test for function call overhead and stack usage
 */
int factorial_recursive(int n) {
    if (n <= 1) return 1;
    return n * factorial_recursive(n - 1);
}

/**
 * Calculate factorial iteratively
 * Tests loop performance
 */
int factorial_iterative(int n) {
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

/**
 * Calculate factorial 1000 times (for benchmarking)
 * Reduces call overhead, measures actual execution
 */
int factorial_bench_1000(int n) {
    int result = 0;
    for (int i = 0; i < 1000; i++) {
        result = factorial_iterative(n);
    }
    return result;
}

/**
 * Calculate fibonacci recursively
 * Classic benchmark for recursion overhead
 */
int fibonacci_recursive(int n) {
    if (n <= 1) return n;
    return fibonacci_recursive(n - 1) + fibonacci_recursive(n - 2);
}

/**
 * Calculate fibonacci iteratively
 * Tests loop and variable performance
 */
int fibonacci_iterative(int n) {
    if (n <= 1) return n;

    int prev = 0, curr = 1;
    for (int i = 2; i <= n; i++) {
        int next = prev + curr;
        prev = curr;
        curr = next;
    }
    return curr;
}

/**
 * Calculate fibonacci 1000 times (for benchmarking)
 * Reduces call overhead, measures actual execution
 */
int fibonacci_bench_1000(int n) {
    int result = 0;
    for (int i = 0; i < 1000; i++) {
        result = fibonacci_iterative(n);
    }
    return result;
}

/**
 * Check if number is prime
 * Tests conditional logic and loops
 */
int is_prime(int n) {
    if (n < 2) return 0;
    if (n == 2) return 1;
    if (n % 2 == 0) return 0;

    for (int i = 3; i * i <= n; i += 2) {
        if (n % i == 0) return 0;
    }
    return 1;
}

/**
 * Count primes up to n
 * Good overall benchmark combining loops and logic
 */
int count_primes(int n) {
    int count = 0;
    for (int i = 2; i <= n; i++) {
        if (is_prime(i)) count++;
    }
    return count;
}

// ============================================================================
// Memory Operations - Array Manipulation
// ============================================================================

/**
 * Sum array elements
 * Tests memory read performance
 */
int array_sum(int* arr, int len) {
    int sum = 0;
    for (int i = 0; i < len; i++) {
        sum += arr[i];
    }
    return sum;
}

/**
 * Sum array 1000 times (for benchmarking)
 * Reduces call overhead, measures actual execution
 */
int array_sum_bench_1000(int* arr, int len) {
    int result = 0;
    for (int i = 0; i < 1000; i++) {
        result = array_sum(arr, len);
    }
    return result;
}

/**
 * Find maximum in array
 * Tests memory read and conditional logic
 */
int array_max(int* arr, int len) {
    if (len == 0) return 0;

    int max = arr[0];
    for (int i = 1; i < len; i++) {
        if (arr[i] > max) max = arr[i];
    }
    return max;
}

/**
 * Reverse array in place
 * Tests memory read/write performance
 */
void array_reverse(int* arr, int len) {
    for (int i = 0; i < len / 2; i++) {
        int temp = arr[i];
        arr[i] = arr[len - 1 - i];
        arr[len - 1 - i] = temp;
    }
}

/**
 * Copy array
 * Tests sequential memory read/write
 */
void array_copy(int* dest, int* src, int len) {
    for (int i = 0; i < len; i++) {
        dest[i] = src[i];
    }
}

/**
 * Bubble sort array
 * Tests intensive memory operations with many reads/writes
 */
void bubble_sort(int* arr, int len) {
    for (int i = 0; i < len - 1; i++) {
        for (int j = 0; j < len - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

/**
 * Binary search in sorted array
 * Tests random access patterns
 */
int binary_search(int* arr, int len, int target) {
    int left = 0, right = len - 1;

    while (left <= right) {
        int mid = left + (right - left) / 2;

        if (arr[mid] == target) return mid;
        if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }

    return -1;  // Not found
}

// ============================================================================
// Combined Workload Functions
// ============================================================================

/**
 * Complex computation combining math and memory
 * Representative of real-world workload
 */
int complex_workload(int* arr, int len) {
    // Sum elements
    int sum = 0;
    for (int i = 0; i < len; i++) {
        sum += arr[i];
    }

    // Compute factorial of sum modulo
    int n = (sum % 10) + 1;  // Keep it reasonable (1-10)
    int fact = 1;
    for (int i = 2; i <= n; i++) {
        fact *= i;
    }

    // Compute fibonacci of result modulo
    int fib_n = (fact % 15) + 1;  // 1-15
    int fib = fibonacci_iterative(fib_n);

    // Mix with array operations
    int max = array_max(arr, len);

    return (fib + max) % 1000;
}

/**
 * Matrix multiplication (small 4x4 matrices)
 * Tests structured memory access patterns
 */
void matrix_multiply_4x4(int* result, int* a, int* b) {
    // result = a * b (all 4x4)
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            result[i * 4 + j] = 0;
            for (int k = 0; k < 4; k++) {
                result[i * 4 + j] += a[i * 4 + k] * b[k * 4 + j];
            }
        }
    }
}

// ============================================================================
// Utility Functions
// ============================================================================

/**
 * Simple checksum calculation
 * Tests bitwise operations and memory access
 */
int checksum(int* data, int len) {
    int sum = 0;
    for (int i = 0; i < len; i++) {
        sum ^= data[i];  // XOR for simple checksum
        sum = (sum << 1) | (sum >> 31);  // Rotate left
    }
    return sum;
}
