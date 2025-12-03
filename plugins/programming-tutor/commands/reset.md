---
name: tutor:reset
description: Reset your learning progress. Use with caution - this cannot be undone!
allowed-tools:
  - Read
  - Write
  - AskUserQuestion
  - Bash
---

# Tutor: Reset Command

Reset learning progress to start fresh.

## Purpose

Allows learners to restart the curriculum from scratch. Useful for:
- Starting over with different approach
- Testing the tutor without affecting real progress (use --test flag instead)
- Clearing corrupted progress data

## ⚠️ WARNING

**This action cannot be undone!** All progress will be permanently lost:
- Completed lessons
- Concept mastery levels
- Review schedules
- Learning preferences
- Struggle points

## Implementation

1. **Check if progress file exists**
   - If doesn't exist: "No progress to reset. Run `/tutor:learn` to begin."
   - If exists: Continue to confirmation

2. **Show current progress summary**
   ```
   Current Progress:
   - Module: {current_module}
   - Lessons completed: {count}
   - Concepts learned: {count}
   - Days of learning: {count}
   ```

3. **Require explicit confirmation**
   - Use AskUserQuestion with scary warning
   - Require typing "RESET" to confirm (not just clicking)
   - Options:
     - "Type RESET to confirm and delete all progress"
     - "Cancel - keep my progress"

4. **If confirmed**:
   - Create backup: `.claude/tutor.local.md.backup-{timestamp}`
   - Delete original progress file
   - Confirm: "Progress reset complete. Backup saved to: {backup_path}"
   - Suggest: "Run `/tutor:learn` to start fresh or `/tutor:assess` to begin with assessment."

5. **If canceled**:
   - "Reset canceled. Your progress is safe."

## Safer Alternative: Test Mode

Instead of resetting, consider using test mode:
```
/tutor:learn --test
/tutor:assess --test
/tutor:project --test
```

Test mode uses separate progress file (`.claude/tutor-test.local.md`) so you can explore without affecting real progress.

## Example Usage

```
$ /tutor:reset

⚠️  WARNING: This will permanently delete all your learning progress!

Current Progress:
- Module: 2 (Data Processing)
- Lessons completed: 9
- Concepts learned: 12
- Mastery level: Average 78%
- Days of learning: 14

This action CANNOT be undone!

Type RESET to confirm deletion, or Cancel to keep your progress:

> RESET

Creating backup: .claude/tutor.local.md.backup-2025-12-02-14-30-15
Progress reset complete.

To start fresh:
- Run `/tutor:learn` to begin with first lesson
- Run `/tutor:assess` to take assessment and find your level

Your old progress is backed up at:
.claude/tutor.local.md.backup-2025-12-02-14-30-15
```

## Backup Location

Backups are saved to: `.claude/tutor.local.md.backup-{ISO-timestamp}`

Example: `.claude/tutor.local.md.backup-2025-12-02-14-30-15`

Backups are NOT automatically deleted. Users can manually restore by:
```bash
cp .claude/tutor.local.md.backup-2025-12-02-14-30-15 .claude/tutor.local.md
```

## Implementation Notes

- Always create backup before deletion
- Use strong confirmation (require typing "RESET")
- Show what will be lost (specific numbers)
- Suggest test mode as safer alternative
- Provide clear path forward after reset
