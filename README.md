sshMole

Simple SSH Tunneling for Windows

by WinterLily

https://github.com/WinterLily/sshMole


________________________________________________________________________________________

DISCLAIMER

This script is written in PowerShell, though utilizes Windows-native SSH, which is only 
included in Windows 7 and above, and the script may generally have some issues with versions
below Windows 10.

________________________________________________________________________________________

WHAT IT DOES

This script will walk you through the steps for constructing an SSH tunnel on a first run. 
More importantly, it allows for the saving of tunnels such that they can be reused later. 

The only limit to the number of active concurrent tunnels is how many ports your machine is 
able to listen on!

________________________________________________________________________________________

USAGE 

First Time:

For your  first time, ensure that the script is in a folder BY ITSELF. 
Using PowerShell (in Admin mode), use "cd" to navigate to that folder, eg. 
    
        cd C:\Users\{yourName}\Documents\scripts\sshMole\
        
From there, execute the script with: 

        ./sshMole.ps1

If you get errors regarding execution policy, run the following: 

        Set-ExecutionPolicy RemoteSigned
        Set-ExecutionPolicy Unrestricted

Then execute it again. 

You will be prompted to import a saved tunnel configuration. Since this is
your first tunnel, respond "n" or hit Enter to continue. 

Follow the prompts to setup your first tunnel.

When you're done, you will be prompted to save the tunnel. If you plan to use the tunnel again, respond "y" and give the tunnel a name. 

Reusing Tunnels:

After the first time, there are two ways to reuse saved tunnels. 

Important to note for EITHER method is that the saved tunnels will automatically be saved in the scripts local directory. If you want to import a tunnel configuration from anywhere else, you will need to supply the FULL filepath. 

1. Initialize the saved tunnel at runtime by launching sshMole with:

        ./sshMole.ps1 {tunnelName}
    
2. Launch sshMole normally, and enter the tunnel name when prompted:

        [-][-] - Do you want to import an existing tunnel configuration? [y/n] Default: [n]: y
        [-][-] - Please enter the path and name of the config file [eg ./configFile.cfg]: {savedTunnelFile}
        {tunnelConfiguration}
        {serverConfiguration}
        [+][+][+] - Config file import succeeded, skipping new tunnel setup process
        [+][+] - Establishing connection
    
Happy tunneling!
