ARG WINDOWS_VERSION
FROM mcr.microsoft.com/windows/servercore:$WINDOWS_VERSION as core

ARG WINDOWS_VERSION
FROM mcr.microsoft.com/powershell:nanoserver-$WINDOWS_VERSION

# # Copy netapi32.dll to support networking.
# # see https://github.com/StefanScherer/dockerfiles-windows/tree/master/netapi-helper
COPY --from=core /windows/system32/netapi32.dll /windows/system32/netapi32.dll

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

USER ContainerAdministrator 
ARG DOCKER_VERSION
RUN $DockerPath = 'C:\Program Files\Docker'; \
    New-Item -Path $DockerPath -ItemType "directory" -Force ; \
    Invoke-WebRequest "https://github.com/StefanScherer/docker-cli-builder/releases/download/${env:DOCKER_VERSION}/docker.exe" -OutFile "$DockerPath\docker.exe" -UseBasicParsing ; \
    setx /M PATH $('{0};{1}' -f  $DockerPath, $env:PATH) ;
USER ContainerUser
