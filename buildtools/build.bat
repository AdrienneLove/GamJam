@echo off

:: [make] clean
echo Cleaning files
@pushd ..
del /s /q /f release > NUL
rmdir /s /q release
@popd

:: make
echo Making release dir
@pushd ..
mkdir release
mkdir release\temp

echo Copying files
xcopy /i /e src release\temp > NUL
copy buildtools\exe\love.exe release\love.exe > NUL
xcopy /i buildtools\lib release\ > NUL
@popd

:: -- zipping
echo Zipping files
@pushd exe
7za a -tzip ..\..\release\main.zip ..\..\release\temp\* -r > NUL
@popd

:: build
@echo Building exe
@pushd ..\release
copy /b love.exe+main.zip game.exe > NUL
@popd

:: clean up
::echo Cleaning up
@pushd ..\release
del /s /f /q temp > NUL
rmdir /s /q temp > NUL
del /f /q main.zip > NUL
del /f /q love.exe > NUL
@popd

echo Done

pause