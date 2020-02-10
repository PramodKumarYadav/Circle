FROM mcr.microsoft.com/powershell:7.0.0-rc.2-alpine-3.8

# vscode or the powershell extension as 2019-09-17 uses /usr/bin/stat during remote debugging connection, but this distro has it in /bin/stat. 
# To replicate the issue: remove the line, build&run, attach to container, install powershell extension via vscode extensions UI, check terminal output.
RUN cp /bin/stat /usr/bin/stat

WORKDIR /circle
COPY . /circle/