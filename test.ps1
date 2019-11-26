Import-Module "$PSScriptRoot\helpers.psm1"

$BuildProps = (Get-GetBuildProperties);
$Tag = Get-TagNames | Select-Object -First 1
$Image = "$($BuildProps.repository)/$Tag";
Invoke-Expression -Command "docker run --isolation=hyperv $Image docker --version";