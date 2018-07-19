#!/bin/bash

####################################
# Folder Structure
####################################
#  exploits
#    windows
#    linux
#    unix
#    mixed
#    todo: add useful exploits aka eternalblue,  dirtycow, etc
####################################

# Start
###################################
#  exploits
####################################

mkdir 'exploits compilations'
cd 'exploits compilations'

####################################
# exploits/windows
####################################

mkdir windows
cd windows

git clone https://github.com/SecWiki/windows-kernel-exploits
git clone https://github.com/abatchy17/WindowsExploits
git clone https://github.com/WindowsExploits/Exploits

cd ../

####################################
# exploits/linux
####################################

mkdir linux
cd linux

git clone https://github.com/SecWiki/linux-kernel-exploits

cd ../

####################################
# exploits/unix
####################################

mkdir unix
cd unix

git clone https://github.com/LukaSikic/Unix-Privilege-Escalation-Exploits-Pack

cd ../

####################################
# exploits/mixed
####################################

mkdir mixed
cd mixed

git clone https://github.com/nixawk/labs
git clone https://github.com/qazbnm456/awesome-cve-poc

cd ../
