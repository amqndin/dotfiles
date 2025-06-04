@echo off
rem This batch file creates a directory and then changes into it.
rem %* captures all arguments passed to the batch file.
mkdir %* -p
if exist %* (
    cd /d %*
) else (
    echo Error: Directory "%*" could not be created or found.
)
