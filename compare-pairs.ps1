param(
    [string]$PairList = ".\pair.txt",
    [string]$OutCsv   = ".\comparison_side_by_side.csv"
)

function Normalize-Line([string]$s) {
    if ($null -eq $s) { return "" }
    if ($s -eq "") { return "<EMPTY LINE>" }
    return $s
}

function Build-LineIndex([string[]]$lines) {
    $map = @{}
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $key = Normalize-Line $lines[$i]
        if (-not $map.ContainsKey($key)) {
            $map[$key] = New-Object System.Collections.Generic.Queue[int]
        }
        $map[$key].Enqueue($i + 1)  # 1-based
    }
    return $map
}

function Take-LineNo($map, [string]$content) {
    if ($map.ContainsKey($content) -and $map[$content].Count -gt 0) {
        return $map[$content].Dequeue()
    }
    return ""
}

function Merge-LineAndText($lineNo, $text) {
    if ([string]::IsNullOrWhiteSpace($text)) { return "" }
    if ([string]::IsNullOrWhiteSpace($lineNo)) { return $text }
    return "$lineNo`: $text"   # e.g. 12: something
}

if (-not (Test-Path $PairList)) { throw "Pair list not found: $PairList" }

$rows = foreach ($line in Get-Content $PairList) {
    $trim = $line.Trim()
    if ([string]::IsNullOrWhiteSpace($trim) -or $trim.StartsWith("#")) { continue }

    $parts = $trim.Split(",", 2)
    if ($parts.Count -ne 2) { Write-Warning "Skipping invalid line: $line"; continue }

    $file1 = $parts[0].Trim()
    $file2 = $parts[1].Trim()

    if (-not (Test-Path $file1) -or -not (Test-Path $file2)) {
        [PSCustomObject]@{
            pair1 = $file1
            pair2 = $file2
            diff_of_file1 = if (-not (Test-Path $file1)) { "[ERROR] file not found" } else { "" }
            diff_of_file2 = if (-not (Test-Path $file2)) { "[ERROR] file not found" } else { "" }
        }
        continue
    }

    $lines1 = Get-Content $file1
    $lines2 = Get-Content $file2
    $idx1 = Build-LineIndex $lines1
    $idx2 = Build-LineIndex $lines2

    $diff = Compare-Object $lines1 $lines2

    $leftTexts  = @($diff | Where-Object SideIndicator -eq "<=" | ForEach-Object { Normalize-Line $_.InputObject })
    $rightTexts = @($diff | Where-Object SideIndicator -eq "=>" | ForEach-Object { Normalize-Line $_.InputObject })

    $left  = foreach ($t in $leftTexts)  { [PSCustomObject]@{ Line=(Take-LineNo $idx1 $t); Text=$t } }
    $right = foreach ($t in $rightTexts) { [PSCustomObject]@{ Line=(Take-LineNo $idx2 $t); Text=$t } }

    $max = [Math]::Max($left.Count, $right.Count)
    while ($left.Count  -lt $max) { $left  += [PSCustomObject]@{ Line=""; Text="" } }
    while ($right.Count -lt $max) { $right += [PSCustomObject]@{ Line=""; Text="" } }

    for ($i = 0; $i -lt $max; $i++) {
        [PSCustomObject]@{
            pair1 = $file1
            pair2 = $file2
            diff_of_file1 = (Merge-LineAndText $left[$i].Line  $left[$i].Text)
            diff_of_file2 = (Merge-LineAndText $right[$i].Line $right[$i].Text)
        }
    }
}

$rows | Export-Csv $OutCsv -NoTypeInformation -Encoding UTF8
Write-Host "Wrote: $OutCsv"
