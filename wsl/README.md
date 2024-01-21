# [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

## Bootstrapping new instances

To quickly bootstrap new WSL instances, execute the scripts in this gist: https://gist.github.com/haakemon/31028cd0b479ce8546c7809f6f0a7400

## Images and instances

To import images, execute `wsl --import [NEWNAME] .\instances\[NEWNAME] .\images\[SOURCE_IMAGE].tar`
To export images, execute `wsl --export [NAME] .\images\[DESTINATION_IMAGE].tar`
