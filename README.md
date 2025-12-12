# Multi File Pair Compare

Simple utilities to compare multiple pairs of text files, line-by-line.

- `compare-pairs.ps1`: PowerShell script that reads `pair.txt` (CSV lines: `pathA,pathB`) and exports `comparison_side_by_side.csv` with line-numbered differences.
- `index.html`: Browser UI to upload pairs, view side-by-side differences, and export CSV.

## Usage (PowerShell)
1. Create `pair.txt` with lines like `.\file1.txt,.\file2.txt`.
2. Run: `.\compare-pairs.ps1 -PairList .\pair.txt -OutCsv .\comparison_side_by_side.csv`.
3. Open the CSV to review differences.

## Usage (Browser)
1. Open `index.html` in a modern browser.
2. Click “+ Them cap file” to add rows; pick File 1 and File 2 per row.
3. Click Compare to see differences; Export CSV to download results.

## Notes
- Blank lines are normalized to `<EMPTY LINE>`.
- Line numbers reflect 1-based positions in each file.
