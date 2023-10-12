#
#   ███████╗███████╗██╗  ██╗███╗   ███╗ ██████╗ ██╗     ███████╗
#   ██╔════╝██╔════╝██║  ██║████╗ ████║██╔═══██╗██║     ██╔════╝
#   ███████╗███████╗███████║██╔████╔██║██║   ██║██║     █████╗  
#   ╚════██║╚════██║██╔══██║██║╚██╔╝██║██║   ██║██║     ██╔══╝  
#   ███████║███████║██║  ██║██║ ╚═╝ ██║╚██████╔╝███████╗███████╗
#   ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚══════╝
#
#              SSH tunneling script for PowerShell 
#                      Written by WinterLily 
#             https://github.com/WinterLily/sshMole
#________________________________________________________________________________________
##
## Parameters 
#
Param([String]$configFile="")
#
## Base functions
#
function importConfig {
    if (Test-Path $configFile -PathType Leaf) {

        $configLines = @(Get-Content -Path $configFile)
        
        if ($configLines.Length -eq 2) {

            $tunnelConfiguration = $configLines[0]
            $serverConfiguration = $configLines[1]

            Write-Output $tunnelConfiguration
            Write-Output $serverConfiguration

            Write-Output "[+][+][+] - Config file import succeeded, skipping new tunnel setup process"

            Write-Output '[+][+] - Establishing connection'
            Write-Output "[+][+][+] - Tunnel configuration: $($tunnelConfiguration)"
            Write-Output "[+][+][+] - Server configuration: $($serverConfiguration)"

            ssh -L $tunnelConfiguration $serverConfiguration


        } else {

            Write-Output "[x][x][x] - The config file is malformed. Please try again or go through the new tunnel setup process to continue"

        }
    } else {

        Write-Output "[x][x][x] - The requested config file does not exist. Please try again or go through the new tunnel setup process to continue"

    }
}
#
function saveConfig ([string]$tunnelConfiguration, [string]$serverConfiguration) {


    $fileExists = 'false'

    while ($fileExists -eq 'false') {

        $fileName = Read-Host "Please enter a name for the config file"


        if (Test-Path -Path $fileName -PathType Leaf ) {

            Write-Output "[-][-][-] - A config file of that name already exists, please choose another one"

        } else {

        write-output 'writing tunnel config'
            
        Write-Output $tunnelConfiguraiton | Out-File -Append $fileName

        get-content -path $fileName

        write-output 'writing server config'

        Write-Output $serverConfiguration | Out-File -Append $fileName

        get-content -path $fileName

        if (Test-Path $fileName -PathType Leaf) {
        
            $configLines = @(Get-Content -Path $fileName)
    
            if ($configLines.Length -eq 2) {
    
                Write-Output "[+][+][+] - Saving config file $($fileName) successful."
    
            } else {
    
                Write-Output "[x][x][x] - The config file is malformed. Please try again or go through the new tunnel setup process to continue"
    
        }

        }

    }
}}


#
#________________________________________________________________________________________
#
## Import Config (Optional)
#
if ($configFile.Length -gt 0) {

    importConfig

} else {

    $defaultImportConfig = 'n'
    
    $userImportConfig = Read-Host "[-][-] - Do you want to import an existing tunnel configuration? [y/n] Default: [$($defaultImportConfig)]"

    if ($userImportConfig -eq 'y') {

        $configFile = Read-Host '[-][-] - Please enter the path and name of the config file [eg ./configFile.cfg]'

        importConfig


    } else {
#
## Declare Initial Variables
#
$localPortExists = 'false'
$destinationServerExists = 'false'
$destinationPortExists = 'false'
$sshServerExists = 'false'
$sshDefaultPort = 22
$sshUserExists = 'false'

if ($configFile.Length -gt 0) {
  
    $configImported = 'true'

} else {
    $configImported = 'false'
}
#
### Welcome message 
#
Write-Output '[+] - Welcome to sshMole, please enter the requested information when prompted and your tunnel will be up in a jiffy!'
Write-Output '[+][+] - Please note that if you have saved tunnel configs, theses can be loaded with [./tunnelMole.ps1 {configFile.cfg}]'
#
#________________________________________________________________________________________
#
## Get User Inputs for Constructing Tunnel IF no config file is present
#
if ($configImported -eq 'false') {
    #
    ### Get destination server
    #
    while ($destinationServerExists -eq 'false') {

        $destinationServer = Read-Host "[-][-] - Please enter the destination server you're trying to connect to"

        if ($destinationServer.Length -gt 0) {
            $destinationServerExists = 'true'
        }
    }
    #
    ### Get destination port
    #
    while ($destinationPortExists -eq 'false') {

        $destinationPort = Read-Host "[-][-] - Please enter the destination port you're trying to connect to"

        if ($destinationPort.Length -gt 0) {
            $destinationPortExists = 'true'
        }
    }
    #
    ### Get local forwarded port
    #
    while ($localPortExists -eq 'false') {

        $localPort = Read-Host "[-][-] - Please enter the local-forwarded port you'd like to use"

        if ($localPort.Length -gt 0) {

                $localPortListening = Get-NetTCPConnection -State Listen |Select-String $localPort 
                
                if ($localPortListening.Length -gt 0) {
                    Write-Output "[-][-] - Your machine is already listening on port $localPort, please try another port."
                } else {
                    $localPortExists = 'true'
                }
            }
        }
    #
    ### Get SSH server 
    #
    while ($sshServerExists -eq 'false') {

        $sshServer = Read-Host "[-][-] - Please enter the SSH server's address or FQDN"

        if ($sshServer.Length -gt 0) {
            $sshServerExists = 'true'
        }

    }
    #
    ### Get SSH port
    #
    while ($sshPortExists -eq 'false') {
        
        $sshPort = Read-Host "[-][-] - Please enter an SSH Port or hit enter to accept the default port number [$($sshDefaultPort)]"
        
        if ($sshPort.Length -eq 0) {
            $sshPort = $sshDefaultPort
        }

        if ($sshPort.Length -gt 0) {
            $sshPortExists = 'true'
        }

    }
    #
    ### Get SSH user 
    #
    while ($sshUserExists -eq 'false') {

        $sshUser = Read-Host "[-][-] - Please enter the username for the SSH server"

        if ($sshUser.Length -gt 0) {
            $sshUserExists = 'true'
        }

    }
}
#________________________________________________________________________________________
#
## Constructing the SSH tunnel
#
Write-Output '[+] - Information gathered, constructing tunnel'
if ($configImported -eq 'false') {
    #
    ### Set the Tunnel configuration
    #
    $tunnelConfiguration = $localPort + ':' + $destinationServer + ':' + $destinationPort
    #
    ### Set the Server configuration
    #
    $serverConfiguration = $sshUser + '@' + $sshServer
    #
    ### List configuration
    # 
    Write-Output "[+][+][+] - Tunnel configuration: $($tunnelConfiguration)"
    Write-Output "[+][+][+] - Server configuration: $($serverConfiguration)"
    #
    ### Save configuration prompt
    #
    $defaultSaveConfig = 'n'

    $saveConfig = Read-Host "[+][+] - Would you like to save this tunnel configuration for future use? [y/n] Default: $($defaultSaveConfig)"

    if ($saveConfig -eq 'y') {
      #  saveConfig ($tunnelConfiguration,$serverConfiguration)
        
    $fileExists = 'false'

    while ($fileExists -eq 'false') {

        $fileName = Read-Host "Please enter a name for the config file"


        if (Test-Path -Path $fileName -PathType Leaf ) {

            Write-Output "[-][-][-] - A config file of that name already exists, please choose another one"

        } else {
            
        Write-Output "$($tunnelConfiguration)`r$($serverConfiguration)" | Out-File -Append -FilePath $fileName

        #write-output $tunnelConfiguration

        #Write-Output $serverConfiguration | Out-File -Append -FilePath $fileName

        if (Test-Path $fileName -PathType Leaf) {
        
            $configLines = @(Get-Content -Path $fileName)
    
            if ($configLines.Length -eq 2) {
    
                Write-Output "[+][+][+] - Saving config file $($fileName) successful."
    
            } else {
    
                Write-Output "[x][x][x] - The config file is malformed. Please try again or go through the new tunnel setup process to continue"
    
        }

        }

        $fileExists = 'true'

    }
}
    }

    ssh -L $tunnelConfiguration $serverConfiguration

}
    }}
#
# END
