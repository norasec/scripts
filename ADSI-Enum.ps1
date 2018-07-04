<#
.SYNOPSIS
    Scripts for Enumeration Local and AD Win Machine with Native Powershell Functions
 
.DESCRIPTION
    *ADSI-Local - Windows Local Machine Users and Groups Enumeration
    *ADSI-Enum-AD - Windows AD Machine Users and Groups Enumeration
    *ADSI-Enum-AD-Forest-Domain - Windows AD Machine Forest and Domain Enumeration
    *ADSI-Searcher - Custom interactive ADSI searcher

.NOTES
    Use on your own. @norasec_
#>

function ADSI-Local
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position = 0, Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $scope,
        [Parameter(Position = 1, Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $fileps1 = "adsi-local-enum.txt"
    )

    Write-Output "[+] Machine Local Users`n" > $fileps1
    Get-LocalUser >> $fileps1

    Write-Output "[+] Machine Local Groups`n" >> $fileps1
    Get-LocalGroup >> $fileps1

    # ms script adapted
    Invoke-Expression ((New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/proxb/PowerShell_Scripts/master/Get-LocalGroupMembership.ps1"))

    $lg = (Get-LocalGroup).name
    if($scope -eq "full"){
        ForEach($line in $($lg -split "`r`n")){
            if(![string]::IsNullOrWhitespace($line)){
                $line=$line.TrimEnd()
                Write-Output "[+] Machine $line Group Memberships`n" >> $fileps1
                $outs = ('Get-LocalGroupMembership -Group "{0}" | ft -autosize >> {1}' -f $line,$fileps1)
                write-output [*] $outs
                iex $outs
                }
            }
        } else {
            Write-Output "[+] Machine Administrators Group Memberships`n" >> $fileps1
            Get-LocalGroupMembership -Group Administrators | ft -autosize >> $fileps1
        }
}

Set-Alias Get-ADSI-Local ADSI-Local
