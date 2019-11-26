Import-Module "$PSScriptRoot\helpers.psm1"

$Tag = Get-TagNames | Select-Object -First 1
Invoke-Expression -Command "docker run --isolation=hyperv $Tag docker --version";