Import-Module "$PSScriptRoot\helpers.psm1"

$ErrorActionPreference = 'Stop';

if ( $env:APPVEYOR_PULL_REQUEST_NUMBER -Or ! $env:APPVEYOR_REPO_BRANCH.Equals("master")) {
  Write-Host 'Nothing to deploy.';
  Exit 0;
}

Write-Host 'Starting deploy...';
# "$env:DOCKER_PASS" | docker login --username "$env:DOCKER_USER" --password-stdin
# docker login with the old config.json style that is needed for manifest-tool
$auth =[System.Text.Encoding]::UTF8.GetBytes("$($env:DOCKER_USER):$($env:DOCKER_PASS)");
$auth64 = [Convert]::ToBase64String($auth);
@"
{
  "auths": {
    "https://index.docker.io/v1/": {
      "auth": "$auth64"
    }
  }
}
"@ | Out-File -Encoding Ascii ~/.docker/config.json

$BuildProps = (Get-GetBuildProperties);
Get-TagNames | ForEach-Object {
  # docker push $($BuildProps.repository)/docker-cli-windows:$version-1607-deprecated
  Write-Host "$($BuildProps.repository)/$_";
}
