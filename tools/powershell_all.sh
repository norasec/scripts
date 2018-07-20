#!/bin/bash

# powershell_all
####################################
# Folder Structure
####################################
# up
#   # powershell
#   powershell_less
#   powershell_frameworks
#   powershell_others
####################################

# Start
####################################
# up
####################################

# mkdir up
# cd up

####################################
# powershell
####################################

# https://github.com/PowerShell/PowerShell
# For Kali: https://www.kali.org/tutorials/installing-powershell-on-kali-linux/
apt update && apt -y install curl gnupg apt-transport-https
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/powershell.list
apt update
apt -y install powershell

# pwsh

####################################
# powershell less
####################################

mkdir powershell_less
cd powershell_less

# Run PowerShell with dlls only
git clone https://github.com/p3nt4/PowerShdll

# PowerLessShell rely on MSBuild.exe
git clone https://github.com/Mr-Un1k0d3r/PowerLessShell

# A JavaScript and VBScript Based Empire Launcher
git clone https://github.com/Cn33liz/StarFighters

# InsecurePowerShell - PowerShell.exe without System.Management.Automation.dll
# https://github.com/cobbr/InsecurePowerShell
mkdir InsecurePowerShell
cd InsecurePowerShell
curl -O https://github.com/cobbr/InsecurePowerShell/releases/download/InsecurePowerShell-v6.0.0-rc.2/InsecurePowerShell-v6.0.0-rc.2-win-x64.zip
unzip InsecurePowerShell-v6.0.0-rc.2-win-x64.zip
cd ..

#Powershell Host running within cscript.exe
git clone https://github.com/Cn33liz/CScriptShell

# PowerShell Runspace .NET Post Exploitation Toolkit in c#
# need to be compiled with Microsoft Visual Studio
git clone https://github.com/Cn33liz/p0wnedShell

# Execute a .net dll method from the command line
# https://github.com/0xbadjuju/rundotnetdll32
mkdir rundotnetdll32
cd rundotnetdll32
curl -O https://github.com/0xbadjuju/rundotnetdll32/releases/download/1.0.0/rundotnetdll32.exe
cd ..

# missing: https://gist.github.com/subTee/47e9d64d0a08c7256ecc8cbed8034c20

cd ..

####################################
# powershell_frameworks
####################################

mkdir powershell_frameworks
cd powershell_frameworks

# empire
git clone https://github.com/EmpireProject/Empire
cd Empire
sudo ./setup/install.sh
cd ..

# empyre
git clone https://github.com/EmpireProject/EmPyre

# empire-web
sudo apt-get install php7.0-curl php5-curl
git clone https://github.com/interference-security/empire-web

# powersploit
git clone https://github.com/PowerShellMafia/PowerSploit

# nishang
git clone https://github.com/samratashok/nishang

# PSattack, mix of frameworks
git clone https://github.com/jaredhaight/PSAttack

cd ..

####################################
# powershell_others
####################################

mkdir powershell_others
cd powershell_others

git clone https://github.com/NetSPI/PowerUpSQL
git clone https://github.com/PowerShellMafia/PowerSCCM

# HostRecon - Fast host and ad recon
https://github.com/dafthack/HostRecon

cd ..
