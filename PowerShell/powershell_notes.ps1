Write-Error "This ain't a usable script, this is a notes file!"
exit

# $var = command
$name = Read-Host "What's your name: "
$command = Get-Uptime

# Assign $var
$var = 'x'
$var = 'x', 'y', 'z'
PS C:\> $var
x
y
z
PS C:\>

# echo - don't use this
Write-Host "Hello" $name -ForegroundColor red -BackgroundColor White

# write-host can't be used with pipes, that's why you have to use Write-Output
Write-Output "Get-Uptime | Get-Member:"
Write-Output $command | Get-Member

# WARNING, ERROR:
Write-Warning "Warning example"
Write-Error "Error example"

# Variables with long names:
${THIS IS A VARIABLE} = "Hello"
Write-Output ${THIS IS A VARIABLE}

# File variables
${C:\users\administrator\test.txt} = 1..5

# Show the execution time of a command:
Measure-Command {command}

# Copy files
Copy-Item $FILE -Destination $DESTINATION
Copy-Item $FILE -Destination \\$REMOTE\$DESTINATION

# $_ $PSCmdlet
$_ == $PSCmdlet

# Get-Command, find information about a command
PS C:\> Get-Command Get-Process
...
PS C:\> $c = Get-Command Get-Process
PS C:\> $c.Parameters
...
PS C:\> $c.Parameters["Paramater Name"]



####### FOR #######

foreach ($item in $collection) {
    Write-Host $item
}

$servers | ForEach-Object{start iexplore http://$_}




##### PARAMATERS #####

<#
.SYNOPSIS
This is the short explanation
.DESCRIPTION
This is the long description
.PARAMETER ParamName
This is for x use
.EXAMPLE
example
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$True)] # Only effects the next parameter
    [string[]]$ParamName='Default Value',
    $NextParam
)

#### FUNCTIONS ####
function Function {
    Write-Output "This is a function"
}

PS C:\> .\function.ps1
PS C:\> Function
Error...
PS C:\> # Nothing Happens as it is discarded after the script exits
PS C:\> . .\function.ps1
PS C:\> Function
This is a function
PS C:\> # Yay...


#### Creating MODULES ####

# The Manual way:
PS C:\> Rename-Item file.ps1 file.psm1
PS C:\> Import-Module .\file.psm1

# The cool way:
PS C:\> $env:PSModulePath -split ";"
...
C:\Users\$USER\Documents\WindowsPowerShell\Modules # <- Place your modules here (You may need to create the folder), create a folder with the SAME name as the script file
...
PS C:\>

<# Invoke-Command:
1. Connect to server
2. Start a PowerShell console on server
3. Run command on server
4. Stop PowerShell on server
All variables created in this Invoke-Command die with the end of the console
#>

PS C:\> Invoke-Command -comp PCNAME {$var = 2}
PS C:\> Invoke-Command -comp PCNAME {$var}
PS C:\> # No output, as the variable dies with the console

# Sessions
# Like a remote shell
# You can open one and keep it open
# You can Invoke-Command without entering a shell, which is more efficient than
#   running Invoke-Command multiple times on a computer

PS C:\> $sessions = New-PSSession -ComputerName PCNAME
PS C:\> Get-PSSession # Show sessions
PS C:\> Invoke-Command -Session $sessions {$var = 2}
PS C:\> Invoke-Command -Session $sessions {$var}
2
PS C:\> # It works, as the console remains open...

PS C:\> # Import modules from remote servers: (Implissit remoting)
PS C:\> Import-PSSession -session $SESSION -Module $MODULES -Prefix remote