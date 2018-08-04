#!/bin/bash

####################################
# Folder Structure
####################################
# up
# Exploits Finders
#   gain access
#   privesc
#     win
#     linux
# Local Enum
#   win
#   linux
####################################

# Start
####################################
# up
####################################

# mkdir up
# cd up

####################################
# up/exploit finders/gain access
####################################

mkdir exploit_finders
cd exploit_finders
mkdir gain_access
cd gain _ccess

git clone https://github.com/1N3/Findsploit
git clone https://github.com/vulnersCom/getsploit
git clone https://github.com/cve-search/cve-search

# uncomment if not installed
# apt-get install exploitdb
cd ../

####################################
# up/exploit finders/priv esc
####################################

mkdir priv_esc
cd priv_esc

####################################
# up/exploit finders/priv esc/linux
####################################

mkdir linux
cd linux

git clone https://github.com/belane/linux-soft-exploit-suggester
git clone https://github.com/spencerdodd/kernelpop/
git clone https://github.com/ngalongc/AutoLocalPrivilegeEscalation
git clone https://github.com/PatrolServer/bashscanner

cd ../

####################################
# up/exploit finders/priv esc/win
####################################

mkdir win
cd win

git clone https://github.com/GDSSecurity/Windows-Exploit-Suggester
git clone https://github.com/rasta-mouse/Sherlock

cd ../../

####################################
# up/local enum
####################################

mkdir local_enum
cd local_enum

####################################
# up/priv esc/linux
####################################

mkdir linux
cd linux

git clone https://github.com/Arr0way/linux-local-enumeration-script/
git clone https://github.com/rebootuser/LinEnum
git clone https://github.com/graniet/Inspector
git clone https://github.com/b3rito/yodo
wget http://www.securitysift.com/download/linuxprivchecker.py
wget http://pentestmonkey.net/tools/audit/unix-privesc-check

cd ../

####################################
# up/priv esc/win
####################################

mkdir win
cd win

git clone https://github.com/A-mIn3/WINspect
git clone https://github.com/411Hall/JAWS
git clone https://github.com/AlessandroZ/BeRoot
git clone https://github.com/SpiderLabs/portia
mkdir windows-privesc-check
cd windows-privesc-check
wget https://raw.githubusercontent.com/1N3/PrivEsc/master/windows/windows-privesc-check/windows-privesc-check.py
wget https://github.com/1N3/PrivEsc/raw/master/windows/windows-privesc-check/windows-privesc-check.exe

cd ../../
