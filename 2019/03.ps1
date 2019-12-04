$s = Get-Content -Path $PSScriptRoot\03-input.txt

$AllWires = New-Object -TypeName System.Collections.ArrayList
$s | ForEach-Object {
    $Current = $_
    $Current = $Current -Split ","
    $Allwires.add($Current) | Out-Null
}

$startX = 0;
$startY = 0;

$AllMaps = New-Object -TypeName System.Collections.ArrayList

$AllWires | ForEach-Object {
    $CurrentWire = $_
    $CurrentLocation = New-Object -TypeName PSCustomObject -Property @{
        x = $startX
        y = $startY
    }
    $CurByY = @{}
    $cost = 0

    $CurrentWire | ForEach-Object {
        $instruction = $_
        $direction = $instruction.Substring(0,1)
        $steps = [int]$instruction.Substring(1)

        for($i = 1; $i -lt ($steps+1); $i++) {
            switch($direction) {
                "U" {
                    $CurrentLocation.y = $CurrentLocation.y + 1
                }

                "D" {
                    $CurrentLocation.y = $CurrentLocation.y - 1
                }

                "R" {
                    $CurrentLocation.x = $CurrentLocation.x + 1
                }

                "L" {
                    $CurrentLocation.x = $CurrentLocation.x - 1
                }
            }
            $cost = $cost + 1
            if(-not $CurByY.ContainsKey($CurrentLocation.y)) {
                $CurByY[$CurrentLocation.y] = @{}
            }
                $CurByY[$CurrentLocation.y][$CurrentLocation.x] = $cost
            
        }
    }
    $AllMaps.Add($CurByY) | Out-Null
    
}

$first = $AllMaps[0]
$second = $AllMaps[1]
$Intersec = @()

$y = $first.Keys
ForEach($key in $y) {
    if($second[$key]) {
        $key2 = $first[$key].Keys
        $key2 | ForEach-Object {
            $s = $_
            if($second[$key].ContainsKey($s)) {
                $Intersec += New-OBject -TypeName PSCustomObject -Property @{
                    "y" = $key
                    "x" = $s
                    "cost" = $first[$key][$s] + $second[$key][$s]
                }
            }
        }
    }
}

$ManHatten = New-Object -TypeName System.Collections.ArrayList

$Intersec | ForEach-Object {
    $cur = $_
    if($cur.x -lt 0) {
        $cur.x = $cur.x * -1
    }
    if($cur.y -lt 0) {
        $cur.y = $cur.y * -1
    }

    $ManHatten.add($cur.x + $cur.y) | Out-Null
}

Write-Warning ("1-Lowest distance: {0}" -f $($ManHatten | Sort-Object | Select -first 1))
Write-Warning ("2-Lowest Cost: {0}" -f $($Intersec | Sort-Object -Property Cost | Select -first 1 | Select-Object -ExpandProperty Cost))