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
                return $memory[$Address]
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
        [Instruction]$instruction = $memory[$pointer]
        switch($instruction.OpCode){
            1 {
                # Add and store
                $a = Read $memory[++$pointer] $instruction.Parameter1Mode
                $b = Read $memory[++$pointer] $instruction.Parameter2Mode
                $writeAddress = $memory[++$pointer]
                $memory[$writeAddress] = $a + $b
                break;
            }
            2 {
                # Multiple and store
                $a = Read $memory[++$pointer] $instruction.Parameter1Mode
                $b = Read $memory[++$pointer] $instruction.Parameter2Mode
                $writeAddress = $memory[++$pointer]
                $memory[$writeAddress] = $a * $b
                break;
            }
            3 {
                # Save input
                $writeAddress = $memory[++$pointer]
                $memory[$writeAddress] = $InputValue
                break;
            }
            4 {
                # Output
                Read $memory[++$pointer] $instruction.Parameter1Mode
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

$answer1 = Execute -InputValue 1
Write-Host "Answer1 : $($answer1[-1])"