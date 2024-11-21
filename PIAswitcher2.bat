@ECHO OFF 
:: This batch file switches between different regions for PIA VPN
::
:: More info...
:: https://helpdesk.privateinternetaccess.com/kb/articles/pia-desktop-command-line-interface-2
:: Run 'region-get.bat' OR 
:: "C:\Program Files\Private Internet Access\piactl.exe" get region
:: for updated region list. Please place desired regions into
:: 
:: regions.txt
::
:: see botto of file to change time interval between region switch
:: 
:: bill s 3-28-2024


TITLE PIAswitcher 2.0
ECHO PIAswitcher 2.0

ECHO Starting PIA...
Start ""  "C:\Program Files\Private Internet Access\pia-client.exe"
TIMEOUT /T 5
ECHO connecting to VPN
"C:\Program Files\Private Internet Access\piactl.exe" connect
TIMEOUT /T 5
TIMEOUT /T 1

REM Check if the regions file exists
IF NOT EXIST regions.txt (
    ECHO Error: regions file not found.
	pause
    EXIT /B 1
)

REM Read regions from the file into variables
SETLOCAL EnableDelayedExpansion
SET count=0
FOR /F "tokens=*" %%A IN (regions.txt) DO (
    SET /A count+=1
    SET "region[!count!]=%%A"
)

:START

REM Iterate through each region variable
FOR /L %%i IN (1,1,%count%) DO (
    ECHO Setting region to !region[%%i]!
    "C:\Program Files\Private Internet Access\piactl.exe" set region !region[%%i]!
    TIMEOUT /T 300
::!! change value above to edit seconds interval between region switch
    ECHO.
)

REM Jump back to the start label to repeat the process
goto START
