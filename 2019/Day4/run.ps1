param(
    [string]$Value = '240920-789857'
)

function HasDouble {
    param(
        [int]$Number
    )

    $Number -match '(.)\1+'
}

function DoesNotDecrease {
    param(
        [int]$Number
    )

    $sorted =  @($Number -split '' | Sort-Object) -join ''
    $sorted -eq $Number
}

function NotOnlyLargeGroups {
    param(
        [int]$Number
    )
    $groups = $Number -split '' |
        Where-Object { $_ } |
        Group-Object |
        Where-Object { $_.Count -eq 2 }

    $groups -ne $null
}

$min,$max = $Value -split '-' | ForEach-Object { [int]::Parse($_) }

$answer1 = $min..$max |
    Where-Object { HasDouble $_ } |
    Where-Object { DoesNotDecrease $_ }

Write-Host "Answer1 : $($answer1.Count)"

$answer2 = $answer1 | Where-Object { NotOnlyLargeGroups $_ }
Write-Host "Answer2 : $($answer2.Count)"