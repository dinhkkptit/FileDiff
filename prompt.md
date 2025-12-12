# Prompt Engineering Notes for File Pair Comparison

## Goal
Surface clear, line-level differences between two text files, matching the semantics of `compare-pairs.ps1`.

## Key Behaviors
- Treat lines as primary units; preserve 1-based line numbers.
- Normalize CRLF/LF differences.
- Represent empty lines explicitly as `<EMPTY LINE>`.
- Export results with columns: `pair1`, `pair2`, `diff_of_file1`, `diff_of_file2`.

## Good Prompts
- “List line-numbered differences between these two files; use `<EMPTY LINE>` for blanks; format as CSV rows with columns pair1, pair2, diff_of_file1, diff_of_file2.”
- “Show side-by-side differences, aligning identical lines and including line numbers for differing lines only.”

## Anti-patterns
- Diffing by character/substring instead of lines.
- Omitting line numbers.
- Dropping blank lines instead of marking them.

## UX Guidance
- Auto-sizing table columns; compact actions column.
- Keep export format aligned with PowerShell output for parity.

## Testing
- Use small fixtures with known differences (timestamps, uptime, serials).
- Include cases with trailing blank lines and repeated identical lines to verify line-number handling queues correctly.
