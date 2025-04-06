# berryOS
A custom operating system, bootloader, recovery, kernel, etc. for the BlackBerry Passport.

## Project Description
berryOS is a custom operating system designed specifically for the BlackBerry Passport. It includes a bootloader, recovery mode, and a custom kernel. The project aims to provide a modern, secure, and efficient operating system for the BlackBerry Passport, extending its usability and functionality.

### Features
- Custom bootloader
- Recovery mode
- Custom kernel
- Modern user interface
- Enhanced security features
- Improved performance and battery life

### Components
- **Bootloader**: Responsible for initializing the hardware and loading the operating system.
- **Recovery Mode**: A special mode that allows users to perform maintenance tasks such as factory reset, system updates, and backups.
- **Kernel**: The core component of the operating system that manages system resources and hardware communication.

## Installation Instructions
### Prerequisites
- A BlackBerry Passport device
- A computer with a USB port
- USB cable
- Development environment set up with necessary tools (e.g., compiler, build tools)

### Steps to Build and Install
1. Clone the repository:
   ```bash
   git clone https://github.com/isdood/berryOS.git
   cd berryOS
   ```
2. Set up the development environment:
   - Install the required tools and dependencies.
   - Configure the build environment.
3. Build the operating system:
   ```bash
   make
   ```
4. Connect the BlackBerry Passport to the computer using a USB cable.
5. Flash the built operating system to the device:
   ```bash
   ./flash.sh
   ```

## Usage Instructions
### Booting the Operating System
1. Power on the BlackBerry Passport.
2. The custom bootloader will initialize and load the operating system.

### Accessing Recovery Mode
1. Power off the device.
2. Press and hold the volume up button and the power button simultaneously until the recovery mode screen appears.

### Using the Kernel
- The custom kernel provides enhanced performance and security features. Users can interact with the kernel through the command line interface or supported applications.

## Contribution Guidelines
### Reporting Issues
- If you encounter any issues or bugs, please report them using the issue tracker on GitHub.

### Submitting Pull Requests
- Fork the repository and create a new branch for your feature or bug fix.
- Make your changes and ensure that the code follows the project's coding standards.
- Submit a pull request with a detailed description of your changes.

### Coding Standards
- Follow the project's coding style and guidelines.
- Write clear and concise commit messages.
- Ensure that your code is well-documented and includes comments where necessary.
