# Multi File Pair Compare

Utilities to compare pairs of text files line-by-line, view differences, and export results.

## What it supports
- File types: plain text formats such as `txt`, `csv`, `log`, and any UTF-8 text file.
- Line-based comparison: preserves 1-based line numbers and marks empty lines as `<EMPTY LINE>`.
- Multiple pairs: process many file pairs in one run (PowerShell) or via multiple rows (HTML UI).

## Quick start (PowerShell)
1) Create `pair.txt` with lines like `path/to/file1.txt,path/to/file2.csv`.  
2) Run `.\compare-pairs.ps1 -PairList .\pair.txt -OutCsv .\comparison_side_by_side.csv`.  
3) Open the CSV to review differences.

## Quick start (Browser UI)
1) Open `index.html` in a modern browser.  
2) Click “+ Them cap file” to add rows; choose File 1 and File 2 (txt, csv, log, etc.).  
3) Click Compare to see differences and Export CSV to download results.

## Notes
- Empty lines are rendered as `<EMPTY LINE>` for clarity.
- Columns in the HTML tables auto-size; the actions column stays compact.
