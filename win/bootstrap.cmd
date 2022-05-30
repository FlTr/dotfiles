@echo off

pushd %~dp0\..

if [%DOT%] EQU [] (
  set DOT=%CD%
  setx DOT %DOT%
  echo DOT env var set. Don't forget to re-login.
)

if not exist git\gitconfig.symlink (
  echo Run script/bootstrap first.
  goto :eof
)

call clink installscripts %DOT%\clink
call clink installscripts %DOT%\clink\completions
call clink installscripts %DOT%\clink\more-completions\src

if [%1] EQU [--skip-scoop] goto skip_scoop

where scoop >nul 2>nul
if errorlevel 1 (
  echo Get: https://scoop.sh
  goto :eof
)

for /F %%a in (win\scooplist) do ( cmd /c scoop install %%a )

:skip_scoop

:: Setup links
set SUDOBAT=%TEMP%\sudo-bootstrap.bat
echo. > %SUDOBAT%

if not exist %CD%\bin\git-up (
  echo mklink %CD%\bin\git-reup %CD%\bin\git-reup >> %SUDOBAT%
)

if not exist %USERPROFILE%\.gitconfig (
  echo mklink %USERPROFILE%\.gitconfig %CD%\git\gitconfig.symlink >> %SUDOBAT%
)

if not exist %LOCALAPPDATA%\clink\.inputrc (
  echo mklink %LOCALAPPDATA%\clink\.inputrc %CD%\clink\inputrc >> %SUDOBAT%
)

if not exist %LOCALAPPDATA%\clink\z.lua (
  for /F %%p in ('scoop prefix z.lua') do (
    echo mklink %LOCALAPPDATA%\clink\z.lua %%p\z.lua >> %SUDOBAT%
  )
)

if exist %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe (
  echo cp %DOT%\win\wt-settings.json %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json >> %SUDOBAT%
)

call sudo cmd /c %SUDOBAT%
del %SUDOBAT%
popd
