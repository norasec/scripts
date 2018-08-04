#!/bin/bash

# payload generators and bypass av
####################################
# Folder Structure
####################################
# up
#  multi_payloads
#  win_payloads
#    av_bypass
#    obfuscation
####################################

# Start
####################################
# up
####################################

# mkdir up
# cd up

####################################
# multi_payloads
####################################

mkdir multi_payloads
cd multi_payloads
git clone https://github.com/D4Vinci/One-Lin3r
apt-get install libncurses5-dev -y
pip install ./One-Lin3r
# multi fast payload gen
git clone https://github.com/0x00-0x00/ShellPop
apt-get install python-argcomplete -y
cd ShellPop
pip install -r requirements.txt
python setup.py install
cd ..
cd ..

####################################
# win_payloads
####################################

mkdir win_payloads
cd win_payloads
# payload framework creation hta,js,jse,vba,vbe,vbs,wsf and delivery in c#
git clone https://github.com/mdsecactivebreach/SharpShooter
cd SharpShooter
pip install -r requirements.txt
cd ..
# donwload cradle, best powershell memory combinations, cli works better on windows
git clone https://github.com/danielbohannon/Invoke-CradleCrafter
# more examples
# https://gist.github.com/Arno0x
# js, vba, hta, vbs
git clone https://github.com/mdsecactivebreach/CACTUSTORCH
# A JavaScript and VBScript shellcode launcher.
git clone https://github.com/Arno0x/ObfuscateCactusTorch

####################################
# av_bypass
####################################

mkdir av_bypass
cd av_bypass
apt-get update
apt-get install shellter
# hta, certutil, pswh downgrade, dde, macros, etc
git clone https://github.com/trustedsec/unicorn
# hta, vba, exe, pswh
git clone https://github.com/hlldz/SpookFlare
cd SpookFlare
pip install -r requirements.txt
cd ..
# most of https://arno0x0x.wordpress.com/2017/11/20/windows-oneliners-to-download-remote-payload-and-execute-arbitrary-code/
git clone https://github.com/GreatSCT/GreatSCT
cd GreatSCT/
cd setup
sudo ./setup.sh -c
cd ..
cd ..
# Undetectable Windows Payload Generation
git clone https://github.com/nccgroup/Winpayloads
cd Winpayloads/
sudo ./setup.sh -c
cd ..
cd ..

####################################
# obfuscation
####################################

mkdir obfuscation
cd obfuscation
# combine cradles with that to avoid detection
git clone https://github.com/danielbohannon/Invoke-Obfuscation
git clone https://github.com/danielbohannon/Invoke-DOSfuscation
git clone https://github.com/Mr-Un1k0d3r/UniByAv
cd ..
