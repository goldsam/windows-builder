Function Get-GetBuildProperties 
{
    return Get-Content -Path properties.json -Raw | ConvertFrom-Json;
}

Function Get-TagNames 
{
    $BuildProps = (Get-GetBuildProperties);
    return @(
      "nanoserver-$($BuildProps.versions.WINDOWS)",
      "latest"
    ) | ForEach-Object { "$($BuildProps.image):$_" };
}

Export-ModuleMember -Function Get-GetBuildProperties, Get-TagNames
