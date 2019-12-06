# Exceptionally Hacky Solution!

$data = Get-Content -Path (Join-Path $PSScriptRoot "06-input.txt") 
$data2 = $data| ForEach-Object {
    [PSCustomObject][ordered]@{
        "inner" = $_ -split "\)" | Select -first 1
        "outer" = $_ -split "\)" | Select -last 1   
    }

}

$AllNodes = @{}
$data2 | ForEAch-Object {
    $AllNodes[$_.Outer] = $_.Inner
    
}

$CounTotal = 0

$AllNodes.Keys | ForEach-Object {
    $current = $AllNodes[$_]
    $currentCount = 1
    while($AllNodes.ContainsKey($current)) {
        $currentCount += 1
        $current = $AllNodes[$current]
    }
    $CounTotal += $currentCount
}

Write-Warning ("Task 1:{0}" -f $CounTotal)

$YouPath = @()
$SanPAth = @()

$current = $AllNodes["YOU"]
while($AllNodes.ContainsKey($current)) {
    $YouPath += $current
    $current = $AllNodes[$current]

}

$SanPAth = @()
$current = $AllNodes["SAN"]
while($AllNodes.ContainsKey($current)) {
    $SanPath += $current
    $current = $AllNodes[$current]

}

$CommonNodes = $YouPath | Where-Object { $_ -in $SanPAth }

$ShortestPath = 9999

$CommonNodes | ForEach-Object {
    $commonNode = $_
    $YouDistance = 0
    $SanDistance = 0
    $TotalDistance = 0
    for ($i = 1; $i -lt $YouPath.Count; $i++)
    { 
        if($YouPath[$i] -eq $CommonNode) {
            $YouDistance = $i
            break;
        }
    }
    for ($i = 1; $i -lt $SanPath.Count; $i++)
    { 
        if($SanPath[$i] -eq $CommonNode) {
            $SanDistance = $i
            break;
        }
    }
    $TotalDistance = $SanDistance + $YouDistance

    if($TotalDistance -lt $ShortestPath) {
        $ShortestPath = $TotalDistance
    }
}

Write-Warning ("Task 2:{0}" -f $ShortestPath)