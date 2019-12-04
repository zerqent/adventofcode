Function Run-OpCode {
    Param($verb, $noun)
    $data = (Get-COntent -Path (Join-Path $PSScriptRoot "02-input.txt")) -split "," | % { [int]$_ }

    # Which was the verb and noun again?
    $data[1] = $verb
    $data[2] = $noun

    $pointer = 0

    while($true) {
        $opcode = $data[$pointer]
        if($opcode -eq 99) {
            break
        }

        $s = $data[$pointer + 1] # pointer
        $t = $data[$pointer + 2] # pointer
        $u = $data[$pointer + 3] # pointer
    
        if($opcode -eq 1) {
            $p = $data[$s] + $data[$t]
        } elseif($opcode -eq 2) {
            $p = $data[$s] * $data[$t]
        }

        $data[$u] = $p
        $pointer = $pointer + 4
    }
    $data
}

# Task 1
$verb = 12
$noun = 2
$output1 = Run-OpCode -verb $verb -noun $noun
Write-Warning ("Task1 : {0}" -f $output1)


# Task 2
$answer = $null
for ($i = 50; $i -lt 100; $i++)
{ 
    # Do nut trust Verb and noun variables on this one...
    $verb = $i
    for ($j = 0; $j -lt 100; $j++)
    { 
        $noun = $j
        $output = Run-OpCode -verb $verb -noun $noun
        if((19690720 - $output[0]) -gt 100) {
            $j = 100
        } elseif($output[0] -eq 19690720) {
            $answer = 100*$verb + $noun
            break
        }               
    }
    if($answer) {
        break
    }

}
Write-Warning ("Task2: {0}" -f $answer)