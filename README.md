# berryOS

A custom operating system, bootloader, recovery, kernel, etc. for the BlackBerry Passport.

## Project Overview

This project aims to create a custom operating system for the BlackBerry Passport, based loosely on BlackBerryOS 10.3.3.2137. The entire OS, including the bootloader, recovery, and kernel, will be written in Zig.

## Goals

1. **Bootloader**: Initialize hardware, set up the stack, and load the kernel into memory.
2. **Kernel**: Manage system resources, provide low-level interfaces, and handle core functionality.
3. **Recovery**: Provide tools and functionality for system recovery and maintenance.

## Development Plan

- **Phase 1**: Develop the bootloader to initialize the hardware and load the kernel.
- **Phase 2**: Develop the kernel to manage system resources and provide core functionality.
- **Phase 3**: Develop the recovery environment for system maintenance and recovery tasks.

## Additional Notes

- To facilitate development and testing, we will utilize/modify an available/existing mobile Linux OS (preferably Arch-based) for the display manager and desktop environment initially. Eventually, these parts will be replaced with entirely custom Zig components.

## Getting Started

### Prerequisites

- Install [Zig](https://ziglang.org/download/)
- Install [Git LFS](https://git-lfs.github.com/)

### Initial Setup

```shell
# Clone the repository
git clone https://github.com/isdood/berryOS.git

# Navigate to the project directory
cd berryOS

# Run the initialization script
./init_project.fish
```

### Contributing

Contributions are welcome! Please fork the repository and submit pull requests.

## License

This project is licensed under the GNU License.
