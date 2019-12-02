param(
    [string]$InputPath = (Join-Path $PSScriptRoot 'input.txt')
)

function Program {
    param(
        [int]$Noun,
        [int]$Verb
    )

    $memory = (Get-Content $InputPath) -split ',' | ForEach-Object { [int]$_ }
    $memory[1] = $Noun
    $memory[2] = $Verb
    $pointer = 0

    $instruction = $memory[$pointer]
    while($instruction -ne 99)
    {
        $a = $memory[$memory[$pointer+1]]
        $b = $memory[$memory[$pointer+2]]
        $writeAddress = $memory[$pointer+3]
        if($instruction -eq 1){
            $memory[$writeAddress] = $a + $b
        } elseif ($instruction -eq 2) {
            $memory[$writeAddress] = $a * $b
        } else {
            Write-Error "Incorrect instruction $instruction"
        }

        $pointer += 4
        $instruction = $memory[$pointer]
    }

    $memory[0]
}

# Answer 1
$answer1 = Program -Noun 12 -Verb 2
Write-Host "Answer1 : $answer1"

# Answer 2 - yuck brute force!
$answer2 = 1..99 | ForEach-Object {
    $noun = $_
    1..99 | ForEach-Object {
        $verb = $_
        $result = Program -Noun $noun -Verb $verb
        if($result -eq 19690720) {
            return "$Noun$Verb"
        }
    }
}
Write-Host "Answer2 : $answer2"