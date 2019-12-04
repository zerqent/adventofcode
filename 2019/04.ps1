$start = 128392
$end = 643281

$valid = @()

for ($i = $start; $i -lt $end+1; $i++)
{ 
    $current = $i
    $f = $current % 10
    $e = [System.Math]::Floor(($current / 10) % 10)
    $d = [System.Math]::Floor(($current / 100) % 10)
    $c = [System.Math]::Floor(($current / 1000) % 10)
    $b = [System.Math]::Floor(($current / 10000) % 10)
    $a = [System.Math]::Floor(($current / 100000) % 10)

    if($f -ge $e -and $e -ge $d -and $d -ge $c -and $c -ge $b -and $b -ge $a) {
        if($f -eq $e -or $e -eq $d -or $d -eq $c -or $c -eq $b -or $b -eq $a) {
            $valid += $i
        }
    }
}

Write-Warning ("Task 1:{0}" -f$valid.Count)

$valid2 = @()

$valid | ForEach-Object {
    $current = $_
    $f = $current % 10
    $e = [int][System.Math]::Floor(($current / 10) % 10)
    $d = [int][System.Math]::Floor(($current / 100) % 10)
    $c = [int][System.Math]::Floor(($current / 1000) % 10)
    $b = [int][System.Math]::Floor(($current / 10000) % 10)
    $a = [int][System.Math]::Floor(($current / 100000) % 10)
    
    $validc = $false
    if($a -eq $b -and $b -ne $c) {
        $validc = $true
    }
    if($a -ne $b -and $b -eq $c -and $c -ne $d) {
        $validc = $true
    }
    if($b -ne $c -and $c -eq $d -and $d -ne $e) {
        $validc = $true
    }
    if($c -ne $d -and $d -eq $e -and $e -ne $f) {
        $validc = $true
    }
    if($d -ne $e -and $e -eq $f) {
        $validc = $true
    }
    if($validc) {
        $valid2 += $current
    }
}

Write-Warning ("Task 2:{0}" -f $valid2.Count)