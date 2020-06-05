FROM mcr.microsoft.com/powershell

WORKDIR /circle
COPY . /circle/

# Execute and exit mode
ENTRYPOINT [ "pwsh", "-File", "/circle/main.ps1" ]

# debug-mode (for say working with vs code)
# CMD tail -f /dev/null

# (location and version of powershell in the container. In debug mode:)
    # PS /circle> which pwsh 
    # /opt/microsoft/powershell/6/pwsh