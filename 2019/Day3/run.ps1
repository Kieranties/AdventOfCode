param(
    [string]$InputPath = (Join-Path $PSScriptRoot 'input.txt')
)

function Traverse {
    param(
        [Parameter(ValueFromPipeline)]
        [string[]]$Points,
        [string]$Label
    )

    begin {
        $x = 0
        $y = 0
        $stepCount = 0
    }

    process {
        function SetPoint ($a,$b) {
            $point = "$a,$b"
            if($_ = $grid[$point]) {
                if(!$_.Keys.Contains($label)) {
                    $_[$label] = $stepCount
                }
            } else {
                $grid[$point] = @{
                    $label = $stepCount
                }
            }
        }

        foreach($step in $Points) {
            $direction = $step[0]
            [int]$distance = $step.Substring(1)

            $incrementor = switch ($direction) {
                'U' {
                    { param([ref]$x, [ref]$y) $y.Value++ }
                }
                'D' {
                    { param([ref]$x, [ref]$y) $y.Value-- }
                }
                'L' {
                    { param([ref]$x, [ref]$y) $x.Value-- }
                }
                'R' {
                    { param([ref]$x, [ref]$y) $x.Value++ }
                }
                Default {
                    Write-Error "Invalid direction $direction"
                }
            }

            1..$distance | ForEach-Object {
                $incrementor.Invoke([ref]$x, [ref]$y)
                $stepCount++
                SetPoint $x $y
            }
        }
    }
}

$wires = Get-Content $InputPath
$wire1 = $wires[0] -split ','
$wire2 = $wires[1] -split ','

$grid = [System.Collections.Generic.Dictionary[[string],hashtable]]::new()

$wire1 | Traverse -Label 'Wire1'
$wire2 | Traverse -Label 'Wire2'

$crossSections = $grid.Keys | Where-Object { $grid[$_].Keys.Count -eq 2 }

# Answer 1
$answer1 = $crossSections |
    ForEach-Object {
        [int]$a,[int]$b = $_.Split(',')
        [Math]::Abs($a) + [Math]::Abs($b)
    } |
    Measure-Object -Minimum |
    Select-Object -ExpandProperty Minimum


Write-Host "Answer1 : $answer1"

# Answer 2
$answer2 = $crossSections|
    ForEach-Object {
        $grid[$_].Values | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    } |
    Measure-Object -Minimum |
    Select-Object -ExpandProperty Minimum

Write-Host "Answer2 : $answer2"