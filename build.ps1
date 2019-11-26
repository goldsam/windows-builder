Import-Module "$PSScriptRoot\helpers.psm1"

$BuildProps = (Get-GetBuildProperties);
$Tags = (Get-TagNames);
$TagArgs = [string]::Join(" ", ($Tags | ForEach-Object{ "-t '$($BuildProps.repository)/$_'"}));
$BuildArgs = [string]::Join(" ", ($BuildProps.versions.PSObject.Properties | ForEach-Object { 
  "--build-arg $($_.Name)_VERSION=$($_.Value)"
}));
Invoke-Expression -Command "docker build --isolation=hyperv $BuildArgs $TagArgs .";;
