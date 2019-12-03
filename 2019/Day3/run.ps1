param(
    [string]$InputPath = (Join-Path $PSScriptRoot 'input.txt')
)

$wires = Get-Content $InputPath
$wire1 = $wires[0] -split ','
$wire2 = $wires[1] -split ','

$grid = [System.Collections.Generic.Dictionary[[string],[System.Collections.Generic.HashSet[string]]]]::new()

function Traverse {
    param(
        [Parameter(ValueFromPipeline)]
        [string[]]$Points,
        [string]$Label
    )

    begin {
        $x = 0
        $y = 0
    }

    process {
        function SetPoint ($a,$b) {
            $point = "$a,$b"
            if($_ = $grid[$point]) {
                $_.Add($Label) | Out-Null
            } else {
                $set = [System.Collections.Generic.HashSet[string]]::new()
                $set.Add($Label) | Out-Null
                $grid[$point] = $set
            }
        }

        foreach($step in $Points) {
            $direction = $step[0]
            [int]$distance = $step.Substring(1)

            switch ($direction) {
                'U' {
                    1..$distance | ForEach-Object {
                        $y++
                        SetPoint $x $y
                    }
                }
                'D' {
                    1..$distance | ForEach-Object {
                        $y--
                        SetPoint $x $y
                    }
                }
                'L' {
                    1..$distance | ForEach-Object {
                        $x--
                        SetPoint $x $y
                    }
                }
                'R' {
                    1..$distance | ForEach-Object {
                        $x++
                        SetPoint $x $y
                    }
                }
                Default {
                    Write-Error "Invalid direction $direction"
                }
            }
        }
    }
}

$wire1 | Traverse -Label 'Wire1'
$wire2 | Traverse -Label 'Wire2'


$answer1 = $grid.Keys |
    Where-Object {
        $grid[$_].Count -eq 2
    } |
    ForEach-Object {
        [int]$a,[int]$b = $_.Replace('-','').Split(',')
        $a + $b
    } |
    Measure-Object -Minimum |
    Select-Object -ExpandProperty Minimum

# Answer 1
Write-Host "Answer1 : $answer1"

# Answer 2 - yuck brute force!
$answer2 = 'missing'
Write-Host "Answer2 : $answer2"