#!/bin/bash

# payload generators and bypass av
####################################
# Folder Structure
####################################
# up
#  multi_payloads
#  win_payloads
#  av_bypass
#  obfuscation
#  others
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
git clone https://github.com/0x00-0x00/ShellPop
cd ..

####################################
# win_payloads
####################################

mkdir win_payloads
cd win_payloads
# payload framework creation hta,js,jse,vba,vbe,vbs,wsf and delivery in c#
git clone https://github.com/mdsecactivebreach/SharpShooter
cd ..

# https://gist.github.com/Arno0x

####################################
# av_bypass
####################################

mkdir av_bypass
cd av_bypass
apt-get update
apt-get install shellter
git clone https://github.com/trustedsec/unicorn
git clone https://github.com/hlldz/SpookFlare
git clone https://github.com/GreatSCT/GreatSCT
# Undetectable Windows Payload Generation
git clone https://github.com/nccgroup/Winpayloads
cd ..

####################################
# obfuscation
####################################

mkdir obfuscation
cd obfuscation
git clone https://github.com/danielbohannon/Invoke-Obfuscation
git clone https://github.com/danielbohannon/Invoke-DOSfuscation
git clone https://github.com/danielbohannon/Invoke-CradleCrafter
git clone https://github.com/Mr-Un1k0d3r/UniByAv
cd ..

####################################
# others
####################################

mkdir others
cd others
# A JavaScript and VBScript shellcode launcher.
git clone https://github.com/mdsecactivebreach/CACTUSTORCH
git clone https://github.com/Arno0x/ObfuscateCactusTorch
cd ..
