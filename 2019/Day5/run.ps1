param(
    [string]$InputPath = (Join-Path $PSScriptRoot 'input.txt')
)

$memory = (Get-Content $InputPath) -split ',' | ForEach-Object { [int]::Parse($_) }

class Instruction {
    [int]$OpCode
    [int]$Parameter1Mode
    [int]$Parameter2Mode
    [int]$Parameter3Mode

    Instruction([string]$value){
        $padded = $value.PadLeft(5, '0')
        $this.Parameter3Mode = [int]::Parse($padded[0])
        $this.Parameter2Mode = [int]::Parse($padded[1])
        $this.Parameter1Mode = [int]::Parse($padded[2])
        $this.OpCode = [int]::Parse($padded[3..4] -join '')
    }
}

function Execute {
    param(
        [int[]]$Buffer,
        [int]$InputValue
    )

    $pointer = 0
    $halt = $false

    function Read {
        param(
            [int]$Address,
            [int]$Mode
        )

        switch ($Mode){
            0 {
                # Position Mode
                return $Buffer[$Address]
            }
            1 {
                # Immediate Mode
                return $Address
            }
            default {
                throw "Invalid Parameter mode: $Mode"
            }
        }
    }

    do {
        [Instruction]$instruction = $Buffer[$pointer]
        switch($instruction.OpCode){
            1 {
                # Add and store
                $a = Read $Buffer[++$pointer] $instruction.Parameter1Mode
                $b = Read $Buffer[++$pointer] $instruction.Parameter2Mode
                $writeAddress = $Buffer[++$pointer]
                $Buffer[$writeAddress] = $a + $b
                break;
            }
            2 {
                # Multiple and store
                $a = Read $Buffer[++$pointer] $instruction.Parameter1Mode
                $b = Read $Buffer[++$pointer] $instruction.Parameter2Mode
                $writeAddress = $Buffer[++$pointer]
                $Buffer[$writeAddress] = $a * $b
                break;
            }
            3 {
                # Save input
                $writeAddress = $Buffer[++$pointer]
                $Buffer[$writeAddress] = $InputValue
                break;
            }
            4 {
                # Output
                Read $Buffer[++$pointer] $instruction.Parameter1Mode
                break;
            }
            5 {
                # Jump if true
                $p1 = Read $Buffer[++$pointer] $instruction.Parameter1Mode
                $p2 = Read $Buffer[++$pointer] $instruction.Parameter2Mode
                if($p1 -ne 0) {
                    $pointer = $p2
                    $pointer--
                }
                break;
            }
            6 {
                # Jump if false
                $p1 = Read $Buffer[++$pointer] $instruction.Parameter1Mode
                $p2 = Read $Buffer[++$pointer] $instruction.Parameter2Mode
                if($p1 -eq 0) {
                    $pointer = $p2
                    $pointer--
                }
                break;
            }
            7 {
                # Less than
                $p1 = Read $Buffer[++$pointer] $instruction.Parameter1Mode
                $p2 = Read $Buffer[++$pointer] $instruction.Parameter2Mode
                $writeAddress = $Buffer[++$pointer]
                if($p1 -lt $p2 ) {
                    $Buffer[$writeAddress] = 1
                } else {
                    $Buffer[$writeAddress] = 0
                }
                break;
            }
            8 {
                # Equals
                $p1 = Read $Buffer[++$pointer] $instruction.Parameter1Mode
                $p2 = Read $Buffer[++$pointer] $instruction.Parameter2Mode
                $writeAddress = $Buffer[++$pointer]
                if($p1 -eq $p2 ) {
                    $Buffer[$writeAddress] = 1
                } else {
                    $Buffer[$writeAddress] = 0
                }
                break;
            }
            99 {
                $halt = $true
                break;
            }
            default {
                throw "Invalid OpCode: $($Instruction.OpCode)"
            }
        }
        $pointer++
    }
    until ($halt)
}

$answer1 = Execute -InputValue 1 -Buffer $memory.Clone()
Write-Host "Answer1 : $($answer1[-1])"

$answer2 = Execute -InputValue 5  -Buffer $memory.Clone()
Write-Host "Answer2 : $answer2"