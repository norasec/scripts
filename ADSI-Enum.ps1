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
                iex $outs
                }
            }
        } else {
            Write-Output "[+] Machine Administrators Group Memberships`n" >> $fileps1
            Get-LocalGroupMembership -Group Administrators | ft -autosize >> $fileps1
        }
}

# Domain to LDAP FQDN format Func Aux
############################################################

function Domain-to-LDAP-FQDN
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position = 0, Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $domainps1
    )

    $res = ""
    $ldapdomain = $domainps1.split(".")
    ForEach($line in $($ldapdomain -split "`r`n")){
        if(![string]::IsNullOrWhitespace($line) -and !($line -eq $ldapdomain[$ldapdomain.Count-1])){
            $res = ("{0}dc={1}," -f $res,$line )
        } else {
        $res = ("{0}dc={1}" -f $res,$line )
        }
    }
    $adsi_s = (New-Object adsisearcher([adsi]"LDAP://$res"))
    return $adsi_s 
}

# AD Users, Groups, Memberships, Domains, Objects Func
############################################################

function ADSI-Enum-AD
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position = 0, Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [adsisearcher]
        $s,

        [Parameter(Position = 1, Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $fileps1 = "adsi-local-enum.txt"
    )

    Write-Output "`n[+] All domains Object"
    $s.filter = "(objectCategory=domain)"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All OU's in Current Domain"
    $s.filter = "(objectcategory=organizationalUnit)"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All Groups Objects"
    $s.filter = "(objectCategory=group)"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All Users Objects"
    $s.filter = "(sAMAccountType=805306368)"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All Computers Objects"
    $s.filter = "(objectCategory=computer)"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All Objects Groups contains adm or test"
    $s.filter = "(&(objectCategory=group)(|(cn=*test*)(cn=*adm*)))"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All Objects Users contains adm or test"
    $s.filter = "(&(objectCategory=user)(|(cn=*test*)(cn=*adm*)))"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All users with Password Never Expires set or not password required"
    # 65536 password never expires + 32 password not required
    $s.filter = "(&(objectCategory=person)(objectClass=user)(userAccountControl:1.2.840.113556.1.4.804:=65568))"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All users never expired password and are enables"
    $s.filter = "(&(objectCategory=person)(objectClass=user)(&(userAccountControl:1.2.840.113556.1.4.804:=65536)(!userAccountControl:1.2.840.113556.1.4.803:=2)(!lockoutTime>=1)))"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All users not required to have a password and are enables"
    $s.filter = "(&(objectCategory=person)(objectClass=user)(&(userAccountControl:1.2.840.113556.1.4.804:=32)(!userAccountControl:1.2.840.113556.1.4.803:=2)(!lockoutTime>=1)))"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All objects with service principal name"
    $s.filter = "(servicePrincipalName=*)"
    $s.FindAll() | fl *  >> $fileps1

    Write-Output "`n[+] All domain local groups"
    $s.filter = "(groupType:1.2.840.113556.1.4.803:=4)"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All servers"
    $s.filter = "(&(objectCategory=computer)(operatingSystem=*server*))"
    $s.FindAll() | fl * >> $fileps1

    # nltest /dclist:<domain>
    Write-Output "`n[+] All Domain Controllers"
    $s.filter = "(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=8192))"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All Exchange servers in the Configuration container"
    $s.filter = "(objectCategory=msExchExchangeServer)"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All trusts established with a domain"
    $s.filter = "(objectClass=trustedDomain)"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All Group Policy objects"
    $s.filter = "(objectCategory=groupPolicyContainer)"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All Read-Only Domain Controllers"
    $s.filter = "(userAccountControl:1.2.840.113556.1.4.803:=67108864)"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All users with mail"
    $s.filter = "(&(objectClass=user)(email=*))"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All users without mail"
    $s.filter = "(&(objectClass=user)!(email=*))"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All empty groups"
    $s.filter = "(&(objectClass=group)(!member=*))"
    $s.FindAll() | fl * >> $fileps1

    Write-Output "`n[+] All account locked"
    $s.filter = "(&(objectCategory=Person)(objectClass=User)(lockoutTime>=1))"
    $s.FindAll() | fl * >> $fileps1
}

# Forest, Domains, Forest Trust, Domain Trust Func
############################################################
#Value  Forest        Domain             Domain Controller
#0      2000          2000 Mixed/Native  2000
#1      2003 Interim  2003 Interim       N/A
#2      2003          2003               2003
#3      2008          2008               2008
#4      2008 R2       2008 R2            2008 R2
#5      2012          2012               2012
#6      2012 R2       2012 R2            2012 R2
#7      2016          2016               2016
# Domain Controller Functional Level
#$dse.domainControllerFunctionality

# Domain Functional Level
#$dse.domainFunctionality

# Forest Functional Level
#$dse.forestFunctionality 

# check Get-ADForest

# Ldap server versions
# $dse = ([ADSI] "LDAP://RootDSE")
# $dse.properties

function ADSI-Enum-AD-Forest-Domain {

    [CmdletBinding()]
    Param
    (
        [Parameter(Position = 0, Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $domainps1,

        [Parameter(Position = 1, Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $scope
    )
    #########
    # Domain
    #########
    write-output "`n[+] Starting AD Domain Enumeration For Domains $domainps1`n"
    $RootDomain = $domainps1
    $DomContxt = new-object System.DirectoryServices.ActiveDirectory.DirectoryContext("Domain",$RootDomain)
    try {
        $NewDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain($DomContxt)

        # Current Domain
        write-output "`n[+] Current Domain`n"
        $NewDomain >> $fileps1

        # Domain Trusts
        write-output "`n[+] Domain Trusts`n"
        $NewDomain.GetAllTrustRelationships() >> $fileps1

        # Domain controllers
        write-output "`n[+] Domain controllers`n"
        $NewDomain.Domaincontrollers >> $fileps1

        # Domain Trust Relationships
        write-output "`n[+] Domain Trust Relationships`n"
        $NewDomain.GetAllTrustRelationships()
        } catch {
            write-output "[-] Error"
            }

    #########
    # Forest
    #########
    # domainps1 = xx.yy.com
    write-output "[+] Starting AD Forest Enumeration For Domain $domainps1`n"
    $ForestRootDomain = $domainps1
    $ForestContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext("Forest", $ForestRootDomain)

    # if forest exists
    try {
        $NewForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetForest($ForestContext)

        # Forest ms
        # https://gallery.technet.microsoft.com/scriptcenter/Forest-and-Domain-6060a979/file/72189/1/ForestInfo.ps1
        # .\ForestInfo.ps1

        # Show Current Forest Information
        write-output "`n[+] Current Forest Information`n"
        $NewForest >> $fileps1

        # Forest Global Catalog - Typically every DC is also a Global catalog
        write-output "`n[+] Forest Global Catalog`n"
        $NewForest.GlobalCatalogs >> $fileps1

        # Forest Global Catalog Sites
        write-output "`n[+] Forest Global Catalog Sites`n"
        $NewForest.Sites >> $fileps1

        # Forest domains
        write-output "`n[+] Forest domains`n"
        $NewForest.Domains >> $fileps1

        # Forest Trusts # nltest /domain_trusts
        write-output "`n[+] Forest Trusts`n"
        $NewForest.GetAllTrustRelationships() >> $fileps1

        # new domains discovered in Forest Trusts
        try{
            $newdom = $NewForest.GetAllTrustRelationships().TargetName
        } catch {
            write-output "[-] Error"
            $scope = "basic"               
            }
        
        if($scope -eq "full"){
            ForEach($line in $($newdom -split "`r`n")){
                if(![string]::IsNullOrWhitespace($line)){
                    $line=$line.TrimEnd()
                    write-output "`n[+] New domain in Forest Trust: $line`n"
                    # format to ldap fqdn
                    $newadsi = Domain_to_LDAP_FQDN($line)
                    # call to enum ad in new adsi
                    write-output "`n[+] Starting AD Enumeration Users and Groups For Domain $line`n"
                    ADSI-Enum-AD $newadsi
                    # call to enum ad domain forest in new forest, basic for not recursivity
                    ADSI-Enum-AD-Forest-Domains $line "basic"
                    }
                }
            }
        } catch {
            write-output "[-] Error"
            }
}

# Searches
############################################################

# aux menu
function searchMenu 
{ 
     param ( 
           [string]$Titulo = 'Options' 
     ) 
     cls 
     Write-Host "================ $Titulo================`n"
     Write-Host "1. Search a specific cn member"
     Write-Host "2. A specific group name"
     Write-Host "3. All members of specified group, including due to group nesting`n"
     Write-Host "x. Press 'x' to finish"
}

# main searcher
function ADSI-Searcher
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Position = 0, Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [adsisearcher]
        $s
    )

    do 
    { 
         searchMenu Searches
         $input = Read-Host "`nSelect an option" 
         switch ($input) 
         { 
           '1' {
                cls 
                '1. Search a specific cn member' 
                $name = Read-Host "[+] Introduce a cn member name: "
                $s.filter = "(cn=*$name*)"
                $s.FindAll().properties | fl *
           } '2' { 
                cls 
                '2. A specific group name' 
                $name = Read-Host "[+] Introduce a group member name: "
                $s.filter = "(&(objectclass=group)(cn=$name))"
                $s.FindAll().properties | fl *
           } '3' { 
                cls 
                '3. All members of specified group, including due to group nesting' 
                $name = Read-Host "[+] Introduce a group member name: "
                $s.filter = "(&(objectclass=group)(cn=$name))"
                $adspath = $s.FindAll().Properties.adspath
                $ads = $adspath.split('//')[2]
                $s.filter = "(memberOf:1.2.840.113556.1.4.1941:=$ads)"
                $s.FindAll().properties | fl *
           } 'x' { 
                return 
           }  
         } 
         pause
    } 
    until ($input -eq 's')

}

Set-Alias Get-ADSI-Local ADSI-Local
Set-Alias Get-ADSI-Enum-AD ADSI-Enum-AD
Set-Alias Get-ADSI-Enum-AD-Forest-Domain ADSI-Enum-AD-Forest-Domains
Set-Alias Invoke-ADSI-Searcher ADSI-Searcher

# Usage
############################################################
# $domain = "micasa.miedificio.com" # current domain pwsh $env:USERDNSDOMAIN # wmic computersystem get domain
# $adsi_obj = Domain-to-LDAP-FQDN $domain

# Get-ADSI-Local full
# Get-ADSI-Enum-AD $adsi_obj
# Get-ADSI-Enum-AD-Forest-Domain $domain full
# Invoke-ADSI-Searcher $adsi_obj
