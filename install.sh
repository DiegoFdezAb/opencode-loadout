#!/bin/bash

# OpenCode Loadout Installer
set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Detect OS and architecture
detect_platform() {
    local os
    local arch
    
    case "$(uname -s)" in
        Linux*) os="linux" ;;
        Darwin*) os="macos" ;;
        *) 
            log_error "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
    
    case "$(uname -m)" in
        x86_64) arch="x64" ;;
        aarch64|arm64) arch="arm64" ;;
        *)
            log_error "Unsupported architecture: $(uname -m)"
            exit 1
            ;;
    esac
    
    echo "${os}-${arch}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check dependencies
check_dependencies() {
    log_info "Checking dependencies..."
    
    local missing=()
    
    if ! command_exists "jq"; then
        missing+=("jq")
    fi
    
    if ! command_exists "curl"; then
        missing+=("curl")
    fi
    
    if [ ${#missing[@]} -ne 0 ]; then
        log_error "Missing dependencies: ${missing[*]}"
        log_info "Install missing dependencies:"
        
        if command_exists "apt-get"; then
            echo "  sudo apt-get update && sudo apt-get install -y ${missing[*]}"
        elif command_exists "brew"; then
            echo "  brew install ${missing[*]}"
        elif command_exists "yum"; then
            echo "  sudo yum install -y ${missing[*]}"
        fi
        
        exit 1
    fi
    
    log_success "All dependencies satisfied"
}

# Check if OpenCode is installed
check_opencode() {
    if ! command_exists "opencode"; then
        log_error "OpenCode CLI is not installed"
        log_info "Install OpenCode first:"
        echo "  npm install -g @opencode/cli"
        echo "  or: bun add -g @opencode/cli"
        exit 1
    fi
    
    log_success "OpenCode CLI found: $(opencode --version 2>/dev/null || echo 'unknown')"
}

# Install the script
install_script() {
    local install_dir="$HOME/.local/bin"
    local script_path="$install_dir/opencode-loadout"
    local symlink_path="$HOME/.local/bin/ocl"
    
    log_info "Installing OpenCode Loadout..."
    
    # Create install directory if it doesn't exist
    mkdir -p "$install_dir"
    
    # Download the script
    local script_url="https://raw.githubusercontent.com/YOUR_USERNAME/opencode-loadout/main/opencode-loadout"
    log_info "Downloading script from: $script_url"
    
    if command_exists "curl"; then
        curl -fsSL "$script_url" -o "$script_path"
    elif command_exists "wget"; then
        wget -q "$script_url" -O "$script_path"
    else
        log_error "Neither curl nor wget found"
        exit 1
    fi
    
    # Make executable
    chmod +x "$script_path"
    
    # Create symlink
    ln -sf "$script_path" "$symlink_path"
    
    # Add to PATH if not already there
    local shell_rc=""
    if [[ -f "$HOME/.bashrc" ]]; then
        shell_rc="$HOME/.bashrc"
    elif [[ -f "$HOME/.zshrc" ]]; then
        shell_rc="$HOME/.zshrc"
    fi
    
    if [[ -n "$shell_rc" ]] && ! grep -q "$install_dir" "$shell_rc"; then
        log_info "Adding $install_dir to PATH in $shell_rc"
        echo "" >> "$shell_rc"
        echo "# OpenCode Loadout" >> "$shell_rc"
        echo "export PATH=\"$install_dir:\$PATH\"" >> "$shell_rc"
        log_warn "Run 'source $shell_rc' or restart your terminal to use the command"
    fi
    
    log_success "Installed OpenCode Loadout to $script_path"
    log_success "Created symlink: $symlink_path"
}

# Initialize directories
init_directories() {
    local config_dir="$HOME/.config/opencode-loadout"
    local presets_dir="$config_dir/presets"
    local profiles_dir="$config_dir/profiles"
    local backups_dir="$config_dir/backups"
    
    log_info "Initializing configuration directories..."
    
    mkdir -p "$presets_dir"
    mkdir -p "$profiles_dir"
    mkdir -p "$backups_dir"
    
    # Download default presets
    local presets_base_url="https://raw.githubusercontent.com/YOUR_USERNAME/opencode-loadout/main/presets"
    local presets=("core.json" "omo.json" "omo-full.json" "orchestra.json")
    
    for preset in "${presets[@]}"; do
        log_info "Downloading preset: $preset"
        if command_exists "curl"; then
            curl -fsSL "$presets_base_url/$preset" -o "$presets_dir/$preset"
        elif command_exists "wget"; then
            wget -q "$presets_base_url/$preset" -O "$presets_dir/$preset"
        fi
    done
    
    # Download default profiles
    local profiles_base_url="https://raw.githubusercontent.com/YOUR_USERNAME/opencode-loadout/main/profiles"
    local profiles=("frontend.json" "backend.json" "fullstack.json" "data.json" "devops.json")
    
    for profile in "${profiles[@]}"; do
        log_info "Downloading profile: $profile"
        if command_exists "curl"; then
            curl -fsSL "$profiles_base_url/$profile" -o "$profiles_dir/$profile"
        elif command_exists "wget"; then
            wget -q "$profiles_base_url/$profile" -O "$profiles_dir/$profile"
        fi
    done
    
    log_success "Configuration initialized in $config_dir"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    if command_exists "opencode-loadout"; then
        log_success "opencode-loadout command available"
    else
        log_error "opencode-loadout command not found"
        return 1
    fi
    
    if command_exists "ocl"; then
        log_success "ocl command available"
    else
        log_warn "ocl command not found (PATH may need update)"
    fi
    
    # Run verify command if available
    if command_exists "opencode-loadout"; then
        log_info "Running built-in verification..."
        opencode-loadout verify || log_warn "Verification completed with warnings"
    fi
    
    log_success "Installation verification complete"
}

# Main installation flow
main() {
    log_info "OpenCode Loadout Installer"
    log_info "Platform: $(detect_platform)"
    echo
    
    check_dependencies
    echo
    
    check_opencode
    echo
    
    install_script
    echo
    
    init_directories
    echo
    
    verify_installation
    echo
    
    log_success "🎉 OpenCode Loadout installed successfully!"
    echo
    log_info "Quick start:"
    echo "  opencode-loadout list          # List available presets"
    echo "  ocl list                       # Same command (shorter)"
    echo "  opencode-loadout switch omo    # Switch to OMO preset"
    echo "  ocl switch omo-full           # Switch to OMO Full preset"
    echo
    log_info "For more help:"
    echo "  opencode-loadout help"
    echo "  ocl help"
}

# Run installer
main "$@"