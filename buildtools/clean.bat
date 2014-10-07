@echo off

:: [make] clean
echo Cleaning files
@pushd ..
del /s /q /f release > NUL
rmdir /s /q release
@popd

echo Done.

pause