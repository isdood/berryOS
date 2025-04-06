#!/usr/bin/env fish

# Initialize project directories
mkdir -p src/kernel
mkdir -p src/recovery
mkdir -p src/bootloader
mkdir -p docs
mkdir -p build

# Create initial files
touch src/kernel/main.zig
touch src/recovery/recovery.zig
touch src/bootloader/bootloader.zig
touch docs/README.md
