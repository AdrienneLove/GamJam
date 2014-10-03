@echo off
cls
set lovezip=love-0.8.0-win-x64

::unzip love libs
mkdir %~dp0lib\%lovezip%
%~dp0lib\7za.exe e %~dp0lib\%lovezip%.zip -o%~dp0lib\%lovezip% -y

::compress source dir
%~dp0lib\7za.exe a -tzip %~dp0lib\%lovezip%\zdshm.zip %~dp0\src\*

::make love2d exe and copy dlls
copy /b %~dp0lib\%lovezip%\love.exe+%~dp0lib\%lovezip%\zdshm.zip %~dp0zdshm.exe
copy /b %~dp0lib\%lovezip%\*.dll %~dp0\

::clean
rmdir %~dp0\lib\%lovezip% /s /q

::copy to release 
%~dp0lib\7za.exe a -tzip %~dp0release\zdshm.zip %~dp0\zdshm.exe %~dp0\*.dll

call clean.bat