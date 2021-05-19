@echo off

pushd %~dp0\..

if "%DOT%" EQU "" (
  set DOT=%CD%
  setx DOT %DOT%
  echo DOT env var set. Don't forget to re-login.
)

if "%NVIM_LISTEN_ADDRESS%" EQU "" (
  set NVIM_LISTEN_ADDRESS=localhost:31337
  setx NVIM_LISTEN_ADDRESS %NVIM_LISTEN_ADDRESS%
)

if not exist git\gitconfig.symlink (
  echo Run script/bootstrap first.
  goto :eof
)

where scoop >nul 2>nul
if errorlevel 1 (
  echo Get: https://scoop.sh
  goto :eof
)

for /F %%a in (win\scooplist) do call scoop install %%a

:: Setup links
set SUDOBAT=%TEMP%\sudo-bootstrap.bat
echo. > %SUDOBAT%

if not exist %LOCALAPPDATA%\nvim\autoload\plug.vim (
  mkdir %LOCALAPPDATA%\nvim\autoload
  echo mklink %LOCALAPPDATA%\nvim\autoload\plug.vim %CD%\vim\vim.symlink\autoload\plug.vim >> %SUDOBAT%
  echo mklink %LOCALAPPDATA%\nvim\init.vim %CD%\vim\vimrc.symlink >> %SUDOBAT%
  echo mklink /D %USERPROFILE%\.vim %CD%\vim\vim.symlink >> %SUDOBAT%
)

if not exist %USERPROFILE%\.gitconfig (
  echo mklink %USERPROFILE%\.gitconfig %CD%\git\gitconfig.symlink >> %SUDOBAT%
)

call sudo cmd /c %SUDOBAT%
del %SUDOBAT%
popd
