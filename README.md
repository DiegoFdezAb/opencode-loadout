# OpenCode Loadout

🚀 **Configuration Manager for OpenCode** - Switch between different OpenCode setups effortlessly with presets and profiles.

![Version](https://img.shields.io/badge/version-0.1.1-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![OpenCode](https://img.shields.io/badge/platform-OpenCode-6495ED.svg)

## Features

- **Presets**: Global plugin combinations and agent setups for different workflows.
- **Profiles**: Project-specific configurations (local overrides) for focused development.
- **Deep Visibility**: Detailed information about active agents, models, and plugins.
- **Backup & Restore**: Safely backup and restore your OpenCode configuration.
- **Plugin Management**: Check which plugins are installed and what's missing.
- **Cross-platform**: Works on Linux and macOS.
- **CLI-first**: Simple command-line interface with short aliases (`ocl`).

## Quick Start

### Installation

```bash
# One-line installer
curl -fsSL https://raw.githubusercontent.com/DiegoFdezAb/opencode-loadout/main/install.sh | bash

# Or download and run manually
wget https://raw.githubusercontent.com/DiegoFdezAb/opencode-loadout/main/install.sh
chmod +x install.sh
./install.sh
```

**Requirements:**
- OpenCode CLI (`npm install -g @opencode/cli`)
- `jq` (JSON processor)
- `curl` or `wget`

### Basic Usage

```bash
# List available presets
ocl list

# Switch to a preset (Global)
ocl switch omo-full

# See current configuration (Global + Local)
ocl current

# Get detailed info about a preset or profile
ocl info omo-full
ocl profile info frontend-heavy
```

## Available Presets

| Preset | Description | Plugins |
|--------|-------------|---------|
| `core` | Vanilla OpenCode (no plugins) | - |
| `omo` | Oh-My-OpenCode with Sisyphus orchestrator | `oh-my-opencode` |
| `omo-full` | Full OMO setup with all agents enabled | `oh-my-opencode` |
| `orchestra` | Open Orchestra multi-agent system | `opencode-orchestrator` |

## Detailed Commands

### Presets (Global)

- **`ocl list`**: List all available global presets.
- **`ocl switch <preset>`**: Switch your global OpenCode configuration.
- **`ocl info <preset>`**: Show detailed information about a preset, including which agents and models are configured.
- **`ocl save <name>`**: Save your current global configuration as a new preset.

### Profiles (Project-Specific)

Profiles allow you to have different agent configurations for different projects (e.g., Gemini for frontend, Claude for backend).

- **`ocl profile list`**: List available project profiles.
- **`ocl profile info <name>`**: Show detailed agent configuration for a profile, including disabled agents.
- **`ocl profile use <name>`**: Apply a profile to the **current directory**. This creates a `.opencode/oh-my-opencode.json` file.
- **`ocl init [preset]`**: Initialize a project directory with a default configuration.

### System

- **`ocl current`**: Show active configuration. It detects if a **Local Profile** is active and shows its specific agent settings, otherwise shows the global preset settings.
- **`ocl check-plugins`**: Verify which plugins are installed on your system.
- **`ocl verify`**: Check the integrity of your OpenCode Loadout installation.
- **`ocl restore [backup]`**: Restore a previous configuration from the `backups/` directory.

## Development

If you want to contribute or modify the tool locally:

```bash
# Clone the repository
git clone https://github.com/DiegoFdezAb/opencode-loadout.git

# Make your changes, then install locally
./dev-install.sh
```

`dev-install.sh` will install the binary and configurations from your local folder directly to your system path.

## Preset Directory Structure

```
~/.config/opencode-loadout/
├── presets/                 # Global preset configurations
├── profiles/                # Project-specific templates
├── schema/                  # JSON Schemas for validation
├── backups/                 # Automatic configuration backups
├── .state                   # Current active preset tracker
└── config.json              # Global tool settings
```

## Contributing

Want to add a preset or a profile? Submit a PR!

1. Fork the repo.
2. Add your JSON file to `presets/` or `profiles/`.
3. Test it using `./dev-install.sh`.
4. Open a Pull Request!

## License

MIT License - see LICENSE file

---

**Made with ❤️ for the OpenCode community**
