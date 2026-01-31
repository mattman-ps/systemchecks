$codes = Import-Csv -Path "BulkLoad\PowerShell\Includes\ScheduleTaskFilters\TaskResultCodes.csv"
$newcodes = @()
$codes | ForEach-Object {
    $myobject = $_
    $decimalValue = [Convert]::ToInt32($myobject.HexValue, 16)
    $myobject | Add-Member -MemberType NoteProperty -Name "DecimalValue" -Value $decimalValue
    $newcodes += $myobject
}
$newcodes | Export-Csv -Path "BulkLoad\PowerShell\Includes\ScheduleTaskFilters\TaskResultCodes_NEW.csv" -Encoding utf8