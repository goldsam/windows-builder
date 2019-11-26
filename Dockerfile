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
# Install Docker CLI
RUN $DockerPath = 'C:\Program Files\Docker'; \
    New-Item -Path $DockerPath -ItemType "directory" -Force ; \
    Invoke-WebRequest $('https://github.com/StefanScherer/docker-cli-builder/releases/download/{0}/docker.exe' -f $env:DOCKER_VERSION) -OutFile "$DockerPath\docker.exe" -UseBasicParsing ; \
    setx /M PATH $('{0};{1}' -f  $DockerPath, $env:PATH) ;

# Install MinGit
ARG GIT_VERSION
ARG GIT_PATCH_VERSION
RUN $GitPath = 'C:\Program Files\Git'; \
    Invoke-WebRequest $('https://github.com/git-for-windows/git/releases/download/v{0}.windows.{1}/MinGit-{0}.{1}-busybox-64-bit.zip' -f $env:GIT_VERSION, $env:GIT_PATCH_VERSION) -OutFile 'mingit.zip' -UseBasicParsing ; \
    Expand-Archive mingit.zip -DestinationPath $GitPath ; \
    Remove-Item mingit.zip -Force ; \
    setx /M PATH $('{0}\mingw64\bin;{1}' -f $GitPath, $env:PATH)
