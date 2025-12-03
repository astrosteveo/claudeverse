# Installation Guide

## Quick Install

The plugin is already installed in this project! It's located at:
```
.claude/plugins/feature-dev-memory/
```

## Manual Installation (for other projects)

1. Copy the entire `feature-dev-memory` directory to your project's `.claude/plugins/` directory:
   ```bash
   cp -r .claude/plugins/feature-dev-memory /path/to/your/project/.claude/plugins/
   ```

2. Ensure all scripts are executable:
   ```bash
   chmod +x .claude/plugins/feature-dev-memory/hooks/*.sh
   chmod +x .claude/plugins/feature-dev-memory/scripts/*.sh
   ```

3. That's it! The plugin will automatically activate when you run `/feature-dev:feature-dev`

## Verification

To verify the plugin is installed correctly:

```bash
# Check plugin structure
tree .claude/plugins/feature-dev-memory/

# Should show:
# .claude/plugins/feature-dev-memory/
# ├── .claude-plugin
# │   └── plugin.json
# ├── hooks
# │   └── SubagentStop.sh
# ├── README.md
# └── scripts
#     ├── save-architecture-spec.sh
#     └── save-exploration-notes.sh
```

## Testing

Run a feature-dev command:
```bash
/feature-dev:feature-dev Add a simple greeting function
```

After the workflow completes (particularly after the Architecture Design phase), check:
```bash
ls -la .claude/memory/feature-specs/
```

You should see timestamped architecture and exploration files.

## Uninstalling

Simply remove the plugin directory:
```bash
rm -rf .claude/plugins/feature-dev-memory
```

Memory files in `.claude/memory/feature-specs/` will remain and can be manually deleted if desired.
