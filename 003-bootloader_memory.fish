#!/usr/bin/env fish

# Update bootloader with memory management code
echo 'const std = @import("std");

// Previous code remains the same until setup_stack()...

fn setup_stack() void {
    // Set up the stack at 1MB mark
    const stack_top = HARDWARE.BASE_MEMORY + HARDWARE.STACK_SIZE;

    // Set up stack segment and pointer
    asm volatile (
        \\mov $0x0, %%ax
        \\mov %%ax, %%ss      // Set stack segment to 0
        \\mov %[stack], %%esp // Set stack pointer
        \\mov %%esp, %%ebp    // Set base pointer
        :
        : [stack] "r" (stack_top)
        : "ax"
    );

    // Initialize stack guard
    const guard_pattern: u32 = 0xDEADBEEF;
    @intToPtr(*volatile u32, stack_top - 4).* = guard_pattern;
}

fn check_memory() void {
    // Basic memory check
    var total_memory: usize = 0;
    var ptr = @intToPtr(*volatile u8, 0);

    while (@ptrToInt(ptr) < 0x1000000) { // Check first 16MB
        const val = ptr.*;
        ptr.* = 0x55;
        if (ptr.* != 0x55) {
            break;
        }
        ptr.* = val;
        total_memory += 0x1000; // Count in 4KB pages
        ptr = @intToPtr(*volatile u8, @ptrToInt(ptr) + 0x1000);
    }

    // Store total memory for kernel use
    @intToPtr(*volatile usize, HARDWARE.BASE_MEMORY - 8).* = total_memory;
}

// Previous code remains the same...
' >> src/bootloader/bootloader.zig

echo "Memory management code has been added to bootloader.zig"
