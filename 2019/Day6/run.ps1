param(
    [string]$InputPath = (Join-Path $PSScriptRoot 'input.txt')
)

$checksums = Get-Content $InputPath

class Orbit {
    [System.Collections.Generic.List[Orbit]]$Children
    [int] $DirectOrbits
    [int] $TotalOrbits
    hidden [bool] $_counted

    Orbit() {
        $this.Children = [System.Collections.Generic.List[Orbit]]::new()
        $this._counted = $false
    }

    [int] CountOrbits([int] $depth) {
        if(!$this._counted) {
            $this.DirectOrbits = $this.Children.Count
            $this.TotalOrbits = $depth
            $depth++

            foreach($child in $this.Children) {
                $childCount = $child.CountOrbits($depth)
                $this.TotalOrbits += $childCount
            }

            $this._counted = $true
        }

        return $this.TotalOrbits
    }
}

function Map {
    param(
        [Parameter(ValueFromPipeline)]
        [string[]]$Orbits
    )

    begin {
        $map = [System.Collections.Generic.Dictionary[string, [Orbit]]]::new()
    }

    process {
        foreach($orbit in $Orbits) {
            $left,$right = $orbit.Split(')')

            $body = $null
            $sattelite = $null
            if($_ = $map[$left]) {
                $body = $_
            } else {
                $body = [Orbit]::new()
                $map[$left] = $body
            }

            if($_ = $map[$right]) {
                $sattelite = $_
            } else {
                $sattelite = [Orbit]::new()
                $map[$right] = $sattelite
            }

            $body.Children.Add($sattelite)
        }
    }

    end {
        $map
    }
}

$map = $checksums | Map
$root = $map['COM']

$answer1 = $root.CountOrbits(0)
Write-Host "Answer1 : $answer1"

$answer2 = ''
Write-Host "Answer2 : $answer2"