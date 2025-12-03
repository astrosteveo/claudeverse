# Installing the Programming Tutor Plugin

## Quick Start

1. **Add the marketplace**:
   ```bash
   claude plugin marketplace add astrosteveo/claudeverse
   ```

2. **Install the `programming-tutor` plugin**:
   ```bash
   # Uses the `plugin@marketplace` syntax
   claude plugin install programming-tutor@claudeverse
   ```

3. **Start learning**:
   ```bash
   claude
   /tutor:learn
   ```



## Troubleshooting

**Plugin not found**:
- Verify plugin directory structure
- Check that `plugin.json` is in `.claude-plugin/` directory
- Ensure Claude Code can read the directory

**Commands not showing**:
- Run `/help` to see if tutor commands appear
- Check command files are in `commands/` directory
- Verify YAML frontmatter is valid

**Progress not saving**:
- Check `.claude/` directory exists and is writable
- Verify progress file path is correct
- Look for error messages during lesson completion

**Skills not loading**:
- Each skill must be in its own subdirectory under `skills/`
- Each skill must have a `SKILL.md` file (case-sensitive)
- Check YAML frontmatter in SKILL.md is valid

## Development Testing

To test modifications to the plugin:

1. Make changes to plugin files
2. Restart Claude Code or reload plugin
3. Test specific components you modified
4. Check logs for errors

## Reporting Issues

If you encounter issues:
1. Check the error message
2. Verify plugin structure matches expected format
3. Test with `--test` flag to isolate issues
4. Check that all required files exist
