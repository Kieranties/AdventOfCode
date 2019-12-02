param(
    [string]$InputPath = (Join-Path $PSScriptRoot 'input.txt')
)

$modules = Get-Content $InputPath

function GetFuel {
    param(
        [Parameter(ValueFromPipeline)]
        [int[]]$Mass,
        [Switch]$Recurse
    )

    process {

        foreach ($entry in $mass) {
            $result = if($entry -lt 2) {
                $entry
            } else {
                $value = ([Math]::Floor(($entry / 3))) -2
                if($Recurse -and $value -gt 2) {
                    $value += GetFuel $value -Recurse
                }
                $value
            }

            if($result -lt 0) { 0 }
            else { $result }
        }
    }
}

#Answer 1
$answer1 = $modules | GetFuel | Measure-Object -Sum | Select-Object -ExpandProperty Sum
Write-Host "Answer1 : $answer1"

# Answer 2
$answer2 = $modules | GetFuel -Recurse | Measure-Object -Sum | Select-Object -ExpandProperty Sum
Write-Host "Answer2 : $answer2"
