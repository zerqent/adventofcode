function Run-OpCode {
    Param($initialInput)

    Set-StrictMode -Version Latest

    $data = (Get-Content -Path (Join-Path $PSScriptRoot "05-input.txt")) -split "," | % { [int]$_ }

    $pointer = 0

    while($true) {
        $ParseOpCode = $data[$pointer]

        $e = [int][System.Math]::Floor(($ParseOpCode / 1) % 10)
        $d = [int][System.Math]::Floor(($ParseOpCode / 10) % 10)
        $c = [int][System.Math]::Floor(($ParseOpCode / 100) % 10)
        $b = [int][System.Math]::Floor(($ParseOpCode / 1000) % 10)
        $a = [int][System.Math]::Floor(($ParseOpCode / 10000) % 10)
        
        $opcode = 10*$d + $e

        #Write-Warning ("ParseOpCode: {0} - OpCode: {1} - Pointer: {2}" -f $ParseOpCode, $opcode, $pointer)
        #Write-Warning ("E:{0} D:{1}: C:{2} B:{3} A:{4}" -f $e,$d,$c,$b,$a)

        switch($opcode) {
            # So this really needs a cleanup
            99 {
                return $output
            }

            1 {
                # Add
                if($c -eq 1) {
                    $data1 = $data[$pointer+1]
                } else {
                    $data1 = $data[$data[$pointer +1]]
                }

                if($b -eq 1) {
                    $data2 = $data[$pointer+2]
                } else {
                    $data2 = $data[$data[$pointer +2]]
                }

                $data[$data[$pointer+3]] = $data1 + $data2
                
                $pointer = $pointer + 4
            }

            2 {
                # Multiply
                if($c -eq 1) {
                    $data1 = $data[$pointer+1]
                } else {
                    $data1 = $data[$data[$pointer +1]]
                }

                if($b -eq 1) {
                    $data2 = $data[$pointer+2]
                } else {
                    $data2 = $data[$data[$pointer +2]]
                }

                if($a -eq 1) {
                   $data[$pointer+3] = $data1 * $data2
                } else {
                    $data[$data[$pointer+3]] = $data1 * $data2
                }
                $pointer = $pointer + 4

            }

            3 {
                # Read input
                $input = $initialInput
                if($c -eq 1) {
                    $data[$pointer+1] = $input #dunno
                } else {
                    $data[$data[$pointer+1]] = $input
                }
                $pointer = $pointer + 2
            }

            4 {
                # Write Output
                if($c -eq 1) {
                    $output = $data[$pointer +1]
                } else {
                    $output = $data[$data[$pointer +1]]
                }

                $pointer = $pointer + 2
            }

            5 {
                # Jump if true
                if($c -eq 1) {
                    $data1 = $data[$pointer+1]
                } else {
                    $data1 = $data[$data[$pointer+1]]
                }
                if($b -eq 1) {
                    $data2 = $data[$pointer+2]
                } else {
                    $data2 = $data[$data[$pointer+2]]
                }

                if($data1 -ne 0) {
                    $pointer = $data2
                } else {
                    $pointer = $pointer + 3
                }
            }

            6 {
                # Jump if false
                if($c -eq 1) {
                    $data1 = $data[$pointer+1]
                } else {
                    $data1 = $data[$data[$pointer+1]]
                }
                if($b -eq 1) {
                    $data2 = $data[$pointer+2]
                } else {
                    $data2 = $data[$data[$pointer+2]]
                }

                if($data1 -eq 0) {
                    $pointer = $data2
                } else {
                    $pointer = $pointer + 3
                }
            }

            7 {
                # Less than
                if($c -eq 1) {
                    $data1 = $data[$pointer+1]
                } else {
                    $data1 = $data[$data[$pointer+1]]
                }
                if($b -eq 1) {
                    $data2 = $data[$pointer+2]
                } else {
                    $data2 = $data[$data[$pointer+2]]
                }
                if($data1 -lt $data2) {
                    $data[$data[$pointer+3]] = 1
                } else {
                    $data[$data[$pointer+3]] = 0
                }

                $pointer = $pointer +4
            }

            8 {
                # equals
                if($c -eq 1) {
                    $data1 = $data[$pointer+1]
                } else {
                    $data1 = $data[$data[$pointer+1]]
                }
                if($b -eq 1) {
                    $data2 = $data[$pointer+2]
                } else {
                    $data2 = $data[$data[$pointer+2]]
                }
                if($data1 -eq $data2) {
                    $data[$data[$pointer+3]] = 1
                } else {
                    $data[$data[$pointer+3]] = 0
                }

                $pointer = $pointer +4

            }

        }
    }
    $data
}
Write-Warning ("Task1:{0}" -f  $(Run-OpCode -initialInput 1))
Write-Warning ("Task2:{0}" -f  $(Run-OpCode -initialInput 5))