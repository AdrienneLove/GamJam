:: To use this script:
:: Add the following files to a zip file.
:: - All files from /src/, main.lua in root folder of zip.
:: - All DLLs from /buildtools/lib in root folder of zip
::
:: Drop love.exe from /buildtools/exe into the same folder as main.zip
:: 
:: Run this file.

@echo off
echo ok surely i cant fuck this up
echo .
echo i hope you didnt forget the DLLs
echo .
copy /b love.exe+main.zip game.exe
pause