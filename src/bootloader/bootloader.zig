const std = @import("std");

// Hardware-specific constants for BlackBerry Passport
const HARDWARE = struct {
    const BASE_MEMORY = 0x00100000;  // 1MB mark
    const STACK_SIZE = 0x4000;       // 16KB stack
    const VIDEO_MEMORY = 0x000B8000; // Standard VGA text mode memory
    const PORTS = struct {
        const SERIAL_PORT = 0x3F8;   // COM1
        const VGA_PORT = 0x3D4;      // VGA controller
    };
};

pub fn main() void {
    // Entry point of the bootloader
    initialize_hardware();
    setup_stack();
    load_kernel();
    jump_to_kernel();
}

fn initialize_hardware() void {
    // Initialize serial port for debugging
    init_serial();

    // Initialize basic display for status messages
    init_display();

    // Disable interrupts during initialization
    asm volatile ("cli");

    // Enable A20 line
    enable_a20();
}

fn init_serial() void {
    // Initialize COM1 serial port
    const PORT = HARDWARE.PORTS.SERIAL_PORT;

    // Disable interrupts
    out(PORT + 1, 0x00);

    // Set baud rate to 9600
    out(PORT + 3, 0x80);    // Enable DLAB
    out(PORT + 0, 0x0C);    // Lower byte
    out(PORT + 1, 0x00);    // Upper byte

    // 8 bits, no parity, one stop bit
    out(PORT + 3, 0x03);

    // Enable FIFO, clear with 14-byte threshold
    out(PORT + 2, 0xC7);
}

fn init_display() void {
    // Clear screen
    var ptr = @intToPtr([*]volatile u16, HARDWARE.VIDEO_MEMORY);
    var i: usize = 0;
    while (i < 80 * 25) : (i += 1) {
        ptr[i] = 0x0720; // White on black, space character
    }
}

fn enable_a20() void {
    // Try enabling A20 through BIOS
    const BIOS_A20_FUNC = 0x2401;
    asm volatile ("int $0x15"
        :
        : [func] "{ax}" (BIOS_A20_FUNC)
        : "memory"
    );

    // If BIOS method fails, try keyboard controller
    // TODO: Implement keyboard controller A20 enable as fallback
}

fn out(port: u16, value: u8) void {
    asm volatile ("outb %[value], %[port]"
        :
        : [value] "{al}" (value),
          [port] "N{dx}" (port)
    );
}

fn setup_stack() void {
    // Will be implemented in 003-bootloader_memory.fish
    @panic("Stack setup not implemented");
}

fn load_kernel() void {
    // Will be implemented in 004-bootloader_kernel.fish
    @panic("Kernel loading not implemented");
}

fn jump_to_kernel() void {
    // Will be implemented in 004-bootloader_kernel.fish
    @panic("Kernel jump not implemented");
}

const std = @import("std");

// Previous code remains the same until setup_stack()...

fn setup_stack() void {
    // Set up the stack at 1MB mark
    const stack_top = HARDWARE.BASE_MEMORY + HARDWARE.STACK_SIZE;

    // Set up stack segment and pointer
    asm volatile (
        \mov $0x0, %%ax
        \mov %%ax, %%ss      // Set stack segment to 0
        \mov %[stack], %%esp // Set stack pointer
        \mov %%esp, %%ebp    // Set base pointer
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

// Previous code remains...

const KERNEL = struct {
    const LOAD_ADDRESS = 0x00100000; // 1MB mark
    const ENTRY_POINT = 0x00100000;  // Kernel entry point
    const MAX_SIZE = 0x00400000;     // 4MB maximum kernel size
};

fn verify_kernel_signature(kernel: [*]const u8) bool {
    // Check for magic number at start of kernel
    return kernel[0] == 0x7F and
           kernel[1] == 0x45 and
           kernel[2] == 0x4C and
           kernel[3] == 0x46; // ELF magic number
}

fn load_kernel() void {
    // Read kernel from storage
    // This is a simplified version - you'll need to implement actual storage reading
    const kernel_storage_addr = @intToPtr([*]const u8, 0x7E00); // After bootloader
    const kernel_load_addr = @intToPtr([*]u8, KERNEL.LOAD_ADDRESS);

    // Copy kernel to load address
    var i: usize = 0;
    while (i < KERNEL.MAX_SIZE) : (i += 1) {
        if (kernel_storage_addr[i] == 0xDE and
            kernel_storage_addr[i + 1] == 0xAD and
            kernel_storage_addr[i + 2] == 0xBE and
            kernel_storage_addr[i + 3] == 0xEF) {
            // Found end marker
            break;
        }
        kernel_load_addr[i] = kernel_storage_addr[i];
    }

    // Verify kernel signature
    if (!verify_kernel_signature(kernel_load_addr)) {
        @panic("Invalid kernel signature");
    }
}

fn jump_to_kernel() void {
    // Disable interrupts before jump
    asm volatile ("cli");

    // Set up segments
    asm volatile (
        \mov $0x10, %%ax
        \mov %%ax, %%ds
        \mov %%ax, %%es
        \mov %%ax, %%fs
        \mov %%ax, %%gs
        :
        :
        : "ax"
    );

    // Jump to kernel entry point
    const kernel_entry = @intToPtr(fn() void, KERNEL.ENTRY_POINT);
    kernel_entry();
}

