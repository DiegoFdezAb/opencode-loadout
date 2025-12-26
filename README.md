# OpenCode Loadout

> Switch between different OpenCode configurations easily

![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![OpenCode](https://img.shields.io/badge/platform-OpenCode-6495ED.svg)

## Overview

OpenCode Loadout is a configuration manager that allows you to switch between different OpenCode setups instantly. Instead of manually editing config files every time you want to change your agent setup, you can simply switch loadouts.

You can use either the full name `opencode-loadout` or the abbreviation `ocl` for all commands.

### Supported Configurations

- **OpenCode Core** - Vanilla OpenCode with default build/plan agents
- **Oh-My-OpenCode (OMO)** - Full-featured plugin with Sisyphus orchestrator and specialized agents
- **Open Orchestra** - Multi-agent hub-and-spoke orchestration system

## Why This Exists

Managing multiple OpenCode configurations manually is painful:

```bash
# To use OMO
echo '"oh-my-opencode"' >> ~/.config/opencode/opencode.json

# To use Open Orchestra
echo '"opencode-orchestrator"' >> ~/.config/opencode/opencode.json

# To go back to vanilla
# Edit the file manually...
```

With OpenCode Loadout:

```bash
# Switch to OMO (use full name or abbreviation)
opencode-loadout switch omo
ocl switch omo

# Switch to Open Orchestra
opencode-loadout switch orchestra
ocl switch orchestra

# Back to vanilla
opencode-loadout switch core
ocl switch core
```

## Feasibility Analysis

### OpenCode Core

✅ **Fully Supported**

- Pure OpenCode with no plugins
- Just needs to ensure `plugin` array is empty or contains only core plugins
- Configuration: `~/.config/opencode/opencode.json`

### Oh-My-OpenCode

✅ **Fully Supported**

OMO is a **pure configuration plugin**:

- Installed via: `bunx oh-my-opencode install`
- Registered in: `~/.config/opencode/opencode.json` → `plugin: ["oh-my-opencode"]`
- Config files:
  - `~/.config/opencode/oh-my-opencode.json` (global config)
  - `.opencode/oh-my-opencode.json` (project-specific config)
- No binary changes, just configuration swaps

**Multi-profile support**: OMO supports project-specific configs via `.opencode/oh-my-opencode.json`. This means we can:
- Create profiles like `frontend-project.json`, `backend-project.json`
- Switch them by symlinking or copying
- Each profile can have different agents, models, and settings enabled/disabled

### Open Orchestra

✅ **Fully Supported**

Open Orchestra is also a **configuration-based plugin**:

- Installed via: `bun add opencode-orchestrator`
- Registered in: `~/.config/opencode/opencode.json` → `plugin: ["opencode-orchestrator"]`
- Config files:
  - `orchestrator.json` or `.opencode/orchestrator.json`
- Provides 6 worker profiles: vision, docs, coder, architect, explorer, memory
- All managed through configuration, no binary changes

**Combination potential**: You can potentially run OMO + Open Orchestra together for maximum orchestration capabilities!

## Installation

### Prerequisites

```bash
# Check OpenCode is installed
opencode --version

# Check Bun is installed (for OMO)
bun --version

# Check jq is installed (required for JSON parsing)
jq --version
```

Install jq:
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt install jq

# Fedora/RedHat
sudo dnf install jq

# Arch
sudo pacman -S jq
```

### Install OpenCode Loadout

```bash
# Clone repo
git clone https://github.com/YOUR_USERNAME/opencode-loadout.git ~/.opencode-loadout

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.opencode-loadout:$PATH"
```

Now you can use either the full name or the abbreviation:

```bash
# Full name
opencode-loadout switch omo

# Abbreviation (recommended)
ocl switch omo
```

Reload your shell:
```bash
source ~/.bashrc   # or ~/.zshrc
```

## Usage

### List Available Presets

```bash
opencode-loadout list
# or
ocl list
```

Output:
```
Available presets:

  core                Vanilla OpenCode (no plugins)
  omo                 Oh-My-OpenCode with Sisyphus orchestrator
  omo-full            Oh-My-OpenCode with all agents and features
  orchestra           Open Orchestra multi-agent system
  omo-orchestra       EXPERIMENTAL - Combined OMO + Open Orchestra
```

### Switch to a Preset

```bash
# Switch to OMO (full name or abbreviation)
opencode-loadout switch omo
ocl switch omo

# Switch to Open Orchestra
opencode-loadout switch orchestra
ocl switch orchestra

# Switch to vanilla OpenCode
opencode-loadout switch core
ocl switch core
```

This will:
1. Backup your current configuration
2. Check if required plugins are installed
3. Update `~/.config/opencode/opencode.json`
4. Show summary of changes

### Check Current Preset

```bash
opencode-loadout current
# or
ocl current
```

Output:
```
[SUCCESS] Current preset: omo
[INFO] Active plugins:
  - oh-my-opencode
```

### Check Installed Plugins

Check which plugins are installed and which presets can be used:

```bash
opencode-loadout check-plugins
# or
ocl check-plugins
```

Output:
```
[INFO] Checking installed plugins...
[INFO] Installed plugins:
  ✓ oh-my-opencode

[INFO] Required plugins for presets:
  omo: ✓ oh-my-opencode
  orchestra: ✗ opencode-orchestrator
  [WARN]   Missing 1 plugin(s)
```

### Switch Without Plugins Installed

If you try to switch to a preset whose plugins aren't installed, you'll get an error:

```bash
opencode-loadout switch orchestra
# or
ocl switch orchestra
```

Output:
```
[ERROR] Plugin(s) non installé(s):
  - opencode-orchestrator
[INFO]   Installation: bun add opencode-orchestrator
```

### Create Custom Preset

```bash
# Copy an existing preset as a template
cp ~/.opencode-loadout/presets/omo-full.json ~/.opencode-loadout/presets/my-custom.json

# Edit it
vim ~/.opencode-loadout/presets/my-custom.json

# Switch to it
opencode-loadout switch my-custom
# or
ocl switch my-custom
```

### View Preset Details

```bash
opencode-loadout info omo-full
# or
ocl info omo-full
```

## Project-Specific Profiles

For OMO, you can have different configurations per project:

### Setup

```bash
# In your project directory
cd ~/projects/my-frontend-app

# Initialize project-specific OMO config
opencode-loadout init omo
# or
ocl init omo
```

This creates `.opencode/oh-my-opencode.json` with project-specific settings.

### Predefined Project Profiles

Create profiles like:

```bash
~/.opencode-loadout/profiles/
├── frontend-heavy.json    # Gemini for UI, Claude for logic
├── backend-api.json       # Claude for API, GPT for docs
├── full-stack.json        # All models balanced
└── research-mode.json     # Emphasis on librarian/explore
```

### Use Project Profile

```bash
cd ~/projects/my-app
opencode-loadout profile use frontend-heavy
# or
ocl profile use frontend-heavy
```

### View Available Profiles

```bash
opencode-loadout profile list
# or
ocl profile list
```

## Preset Directory Structure

```
~/.opencode-loadout/
├── presets/                 # Global preset configurations
│   ├── core.json
│   ├── omo.json
│   ├── omo-full.json
│   ├── orchestra.json
│   └── omo-orchestra.json
├── profiles/                # Project-specific profiles
│   ├── frontend-heavy.json
│   ├── backend-api.json
│   ├── full-stack.json
│   └── research-mode.json
├── backups/                 # Backup configs
│   └── backup-2025-01-15.json
├── opencode-loadout         # Main CLI script
├── ocl                     # Symlink to opencode-loadout
└── config.json              # OpenCode Loadout settings
```

## Configuration

### Global Config

`~/.opencode-loadout/config.json`:

```json
{
  "$schema": "./schema/presets.schema.json",
  "defaultPreset": "core",
  "autoBackup": true,
  "backupDir": "~/.opencode-loadout/backups",
  "opencodeConfigPath": "~/.config/opencode/opencode.json",
  "plugins": {
    "oh-my-opencode": {
      "installCmd": "bunx oh-my-opencode install",
      "configPath": "~/.config/opencode/oh-my-opencode.json"
    },
    "opencode-orchestrator": {
      "installCmd": "bun add opencode-orchestrator",
      "configPath": "~/.config/opencode/opencode.json"
    }
  }
}
```

### Preset Schema

Each preset in `presets/*.json`:

```json
{
  "$schema": "../schema/preset.schema.json",
  "name": "omo-full",
  "description": "Oh-My-OpenCode with all features enabled",
  "plugins": ["oh-my-opencode"],
  "requires": {
    "oh-my-opencode": "latest"
  },
  "config": {
    "opencode": {
      "plugin": ["oh-my-opencode"]
    },
    "omo": {
      "sisyphus_agent": {
        "disabled": false,
        "builder_enabled": true,
        "planner_enabled": true
      },
      "agents": {
        "oracle": { "model": "openai/gpt-5.2" },
        "librarian": { "model": "anthropic/claude-sonnet-4-5" }
      }
    }
  }
}
```

### Project Profile Schema

`profiles/*.json`:

```json
{
  "$schema": "../schema/profile.schema.json",
  "name": "frontend-heavy",
  "description": "Optimized for frontend development",
  "omo": {
    "agents": {
      "frontend-ui-ux-engineer": { "model": "google/gemini-3-pro-high" },
      "oracle": { "model": "google/gemini-3-pro-medium" }
    },
    "disabled_agents": ["librarian", "explore"],
    "disabled_hooks": ["comment-checker"]
  }
}
```

## Advanced Workflows

### Quick Start with Different Setups

```bash
# Morning: Research phase - use librarian/explore
opencode-loadout switch omo-research
ocl switch omo-research

# Afternoon: Implementation - use Sisyphus with all agents
opencode-loadout switch omo-full
ocl switch omo-full

# Evening: Light coding - use vanilla OpenCode
opencode-loadout switch core
ocl switch core
```

### Multi-Project Setup

```bash
# Project A: Frontend with Gemini
cd ~/projects/frontend-app
opencode-loadout profile use frontend-heavy
ocl profile use frontend-heavy

# Project B: Backend with Claude
cd ~/projects/backend-api
opencode-loadout profile use backend-api
ocl profile use backend-api

# Project C: Full stack
cd ~/projects/monolith
opencode-loadout profile use full-stack
ocl profile use full-stack
```

### Restore from Backup

```bash
opencode-loadout restore
opencode-loadout restore --list  # List all backups
opencode-loadout restore backup-2025-01-15.json  # Restore specific

# Or using abbreviation
ocl restore
ocl restore --list
ocl restore backup-2025-01-15.json
```

### Verify Setup

```bash
opencode-loadout verify
# or
ocl verify
```

This checks:
- OpenCode version
- Plugin installation status
- Config file syntax
- Required dependencies

## Troubleshooting

### Plugin not loading

```bash
# Check if plugin is installed
opencode-loadout check-plugins
ocl check-plugins

# Install missing plugin
bunx oh-my-opencode install  # For OMO
bun add opencode-orchestrator     # For Orchestra
```

### Config got messed up

```bash
# Restore from backup
opencode-loadout restore
ocl restore
```

### Verify current setup

```bash
opencode-loadout verify
ocl verify
```

## Future Enhancements

### Phase 2 Features

- **Auto-detect project type** → Suggest appropriate profile
- **Hot-swap** → Change config without restarting OpenCode
- **Preset marketplace** → Share and download community presets
- **Preset builder UI** → Visual configuration editor
- **Metrics tracking** → See which presets/models you use most

### Phase 3 Ideas

- **Adaptive switching** → Auto-switch based on task type
- **Model load balancing** → Distribute across multiple API keys
- **Team presets** → Shared configs for teams
- **Integration with Oh-My-OpenCode updates** → Auto-pull new features

## Contributing

Want to add a preset? Submit a PR!

```bash
# Fork the repo
git clone https://github.com/YOUR_USERNAME/opencode-loadout.git

# Add your preset
vim presets/my-awesome-preset.json

# Test it
opencode-loadout switch my-awesome-preset
ocl switch my-awesome-preset

# PR!
```

## License

MIT License - see LICENSE file

## Acknowledgments

- **OpenCode** - https://github.com/sst/opencode
- **Oh-My-OpenCode** - https://github.com/code-yeongyu/oh-my-opencode
- **Open Orchestra** - https://github.com/0xSero/open-orchestra

## Related Projects

- [sst/opencode](https://github.com/sst/opencode) - The core OpenCode project
- [code-yeongyu/oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode) - Full-featured OMO plugin
- [0xSero/open-orchestra](https://github.com/0xSero/open-orchestra) - Multi-agent orchestration

---

**Made with ❤️ for the OpenCode community**
