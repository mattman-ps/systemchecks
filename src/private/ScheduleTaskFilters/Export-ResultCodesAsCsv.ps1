# Convert file to CSV
$lines = Get-Content "BulkLoad\PowerShell\Includes\ScheduleTaskFilters\Original_TaskResultCodes.txt"
$records = [System.Collections.ArrayList]::new()
$record = @()

for ($i = 0; $i -lt $lines.Count; $i++) {
    $record = [System.Collections.ArrayList]$record; $null = $record.Add($lines[$i])
    if (($i + 1) % 3 -eq 0) {
        $null = $records.Add(($record -join ","))
        $record = @()
    }
}

# handle any remaining lines
if ($record.Count -gt 0) {
    $null = $records.Add(($record -join ","))
}

$ResultCodesHeader = "Code,HexValue,Description"
$ResultCodesHeader | Set-Content "BulkLoad\PowerShell\Includes\ScheduleTaskFilters\TaskResultCodes.txt" -Encoding utf8
$records | Add-Content "BulkLoad\PowerShell\Includes\ScheduleTaskFilters\TaskResultCodes.txt" -Encoding utf8

# Add decimal value for the hex
$codes = Import-Csv -Path "BulkLoad\PowerShell\Includes\ScheduleTaskFilters\TaskResultCodes.txt"
$newcodes = [System.Collections.ArrayList]::new()
$codes | ForEach-Object {
    $myobject = $_
    $decimalValue = [Convert]::ToInt32($myobject.HexValue, 16)
    $myobject | Add-Member -MemberType NoteProperty -Name "DecimalValue" -Value $decimalValue
    $null = $newcodes.Add($myobject)
}

# output the file
$newcodes | Export-Csv -Path "BulkLoad\PowerShell\Includes\ScheduleTaskFilters\TaskResultCodes.csv" -Encoding utf8