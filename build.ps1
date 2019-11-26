Import-Module "$PSScriptRoot\helpers.psm1"

$BuildProps = (Get-GetBuildProperties);
$Tags = (Get-TagNames);
$TagArgs = [string]::Join(" ", ($Tags | ForEach-Object{ "-t '$($BuildProps.repository)/$_'"}));
Invoke-Expression -Command "docker build --isolation=hyperv --build-arg WINDOWS_VERSION=$($BuildProps.windowsVersion) --build-arg DOCKER_VERSION=$($BuildProps.dockerVersion) $TagArgs .";
