#!/usr/bin/env fish

# Create bootloader file with hardware initialization code
echo 'const std = @import("std");

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
' > src/bootloader/bootloader.zig

echo "Enhanced bootloader code has been written to src/bootloader/bootloader.zig"
