Function Get-GetBuildProperties 
{
    return Get-Content -Path properties.json -Raw | ConvertFrom-Json;
}

Function Get-TagNames 
{
    $BuildProps = (Get-GetBuildProperties)
    return @(
      "$($BuildProps.windowsVersion)-$($BuildProps.dockerVersion)",
      "$($BuildProps.windowsVersion)",
      "latest"
    ) | ForEach-Object { "$($BuildProps.image):$_" };
}

Export-ModuleMember -Function Get-GetBuildProperties, Get-TagNames
