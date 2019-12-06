param(
    [string]$InputPath = (Join-Path $PSScriptRoot 'input.txt')
)

$checksums = Get-Content $InputPath

class GraphIndex {
    [int]$Index
    [string]$Name
}

class Orbit {
    [System.Collections.Generic.List[Orbit]]$Children
    [string] $Name
    [string] $Parent
    [int] $DirectOrbits
    [int] $TotalOrbits
    [int] $Depth
    hidden [bool] $_counted

    Orbit([string]$Name) {
        $this.Name = $Name
        $this.Parent = [string]::Empty
        $this.Children = [System.Collections.Generic.List[Orbit]]::new()
        $this._counted = $false
    }

    [int] CountOrbits([int] $depth) {
        if(!$this._counted) {
            $this.Depth = $depth
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
        [string]$parent = [string]::Empty
    }

    process {
        foreach($orbit in $Orbits) {
            $left,$right = $orbit.Split(')')

            $body = $null
            $sattelite = $null
            if($_ = $map[$left]) {
                $body = $_
            } else {
                $body = [Orbit]::new($left)
                $map[$left] = $body
            }

            if($_ = $map[$right]) {
                $sattelite = $_
            } else {
                $sattelite = [Orbit]::new($right)
                $map[$right] = $sattelite
            }

            $parent = $left
            $sattelite.Parent = $parent
            $body.Children.Add($sattelite)

        }
    }

    end {
        $map
    }
}

function Tour {
    param (
        [Orbit]$Orbit,
        [System.Collections.Generic.List[GraphIndex]]$List,
        [int]$Counter
    )

    $self = [GraphIndex]@{
        Name = $orbit.Name
        Index = $Counter
    }

    $list.Add($self)

    foreach($child in $orbit.Children) {
        $Counter++
        Tour $child $List $counter
        $list.Add($self)
    }

}

$map = $checksums | Map
$root = $map['COM']

$answer1 = $root.CountOrbits(0)
Write-Host "Answer1 : $answer1"

$result = [System.Collections.Generic.List[GraphIndex]]::new()
Tour $root $result 1
$youParent = $map[($map['YOU'].Parent)]
$sanParent = $map[($map['SAN'].Parent)]

$youIndex = $result.FindIndex({$args[0].Name -eq $youParent.Name})
$sanIndex = $result.FindIndex({$args[0].Name -eq $sanParent.Name})

$slice = $result[($youIndex+1)..($sanIndex)]
$lca = ($slice | Sort-Object -Property index)[0].Name
$lcaOrbit = $map[$lca]


$answer2 = ($youParent.Depth - $lcaOrbit.Depth) + ($sanParent.Depth - $lcaOrbit.Depth)



Write-Host "Answer2 : $answer2"