@echo off
REM
REM Copyright (c) 2016 Intel Corporation.
REM All rights reserved.
REM
REM Redistribution and use in source and binary forms, with or without
REM modification, are permitted provided that the following conditions
REM are met:
REM
REM * Redistributions of source code must retain the above copyright
REM notice, this list of conditions and the following disclaimer.
REM * Redistributions in binary form must reproduce the above copyright
REM notice, this list of conditions and the following disclaimer in
REM the documentation and/or other materials provided with the
REM distribution.
REM * Neither the name of Intel Corporation nor the names of its
REM contributors may be used to endorse or promote products derived
REM from this software without specific prior written permission.
REM
REM THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
REM "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
REM LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR
REM A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
REM OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
REM SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
REM LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
REM DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
REM THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
REM (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
REM OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
REM

setlocal EnableDelayedExpansion

set lP=%~dp0
set lP=%lP:~0,-1%


echo.
echo ************************************************************
echo *                                                          *
echo *            Windows IoT Core Image Installer              *
echo *                                                          *
echo ************************************************************


echo.
echo Enumetating the disks and finding SD disk type.

echo list disk  > %lp%\dpscript.txt
call diskpart /s %lP%\dpscript.txt > diskpart_output.txt

set /A StartParsing=0
set /A CurrentDiskNumber=0
set /A CurrentDiskStatus=0
set NumberOfDisks=0

FOR /F "tokens=1,2,3" %%i IN (diskpart_output.txt) DO (

    if %%i == Disk (
        if %%j == ### (
            echo.
        ) else (

            set /A "NumberOfDisks+=1"

            echo.
            echo Checking Disk## %%j.

            if %%k == Online (
                echo Disk## %%j is Online
                echo sel disk %%j > %lP%\dpscript.txt
                echo detail disk >> %lp%\dpscript.txt
                call diskpart /s %lP%\dpscript.txt > diskpart_output_1.txt

                FOR /F "tokens=1,3" %%a IN (diskpart_output_1.txt)  DO (
                    if %%a == Type  (
                        if %%b == SD (
                            echo Disk## %%j is of type SD 
                            set /A CurrentDiskNumber=%%j
                            goto Install
                        ) else (
                            echo The Disk type is not SD. It is %%b. Skipping to the next disk.
                        )
                    )
                )
            ) else (
                echo Disk## %%j is Offline. Skipping to the next disk.
            )
        )
    )
)
goto Error

:Install
echo.
echo Installing IOTCore FFU on Disk## %CurrentDiskNumber%.
echo.
echo.

if exist c:\flash.ffu (
    dism.exe /apply-image /ImageFile:c:\Flash.ffu /ApplyDrive:\\.\PhysicalDrive%CurrentDiskNumber%  /skipplatformcheck
) else if exist d:\flash.ffu (
    dism.exe /apply-image /ImageFile:d:\Flash.ffu /ApplyDrive:\\.\PhysicalDrive%CurrentDiskNumber%  /skipplatformcheck
) else if exist e:\flash.ffu (
    dism.exe /apply-image /ImageFile:e:\Flash.ffu /ApplyDrive:\\.\PhysicalDrive%CurrentDiskNumber%  /skipplatformcheck
) else if exist f:\flash.ffu (
    dism.exe /apply-image /ImageFile:f:\Flash.ffu /ApplyDrive:\\.\PhysicalDrive%CurrentDiskNumber%  /skipplatformcheck
) else (
    echo ERROR: Couldn't locate the FFU image "flash.ffu".
)

if exist c:\windows\system32\ACPITABL.dat (
    del c:\windows\system32\ACPITABL.dat
) else if exist d:\windows\system32\ACPITABL.dat (
    del d:\windows\system32\ACPITABL.dat
) else if exist e:\windows\system32\ACPITABL.dat (
    del e:\windows\system32\ACPITABL.dat
) else if exist f:\windows\system32\ACPITABL.dat (
    del f:\windows\system32\ACPITABL.dat
)

goto End

:Error
echo.
echo.
echo ERROR: Couldn't find the disk (out of %NumberOfDisks% disks) with type SD to flash the IotCore Image.. Exiting.
goto End

:End

pause
