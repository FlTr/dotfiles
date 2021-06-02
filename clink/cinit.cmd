@echo off

if [%1] EQU [--path-only] goto path_only

:: Start the goodness
call clink inject --quiet

:: Setup aliases
if not exist %DOT%\clink\aliases (
  "%GIT_INSTALL_ROOT%\usr\bin\bash" --login %DOT%\clink\collect-aliases.sh
)
doskey /macrofile=%DOT%\clink\aliases

:: ENV
set _ZL_NO_CHECK=1
set FZF_DEFAULT_COMMAND=fd -t f
set FZF_DEFAULT_OPTS=--height=40%% --layout=reverse --bind "alt-e:execute(nvr {})"

:: Clean title
title cmd

:: Setup PATH
:path_only
if exist %USERPROFILE%\bin\ set PATH=%USERPROFILE%\bin;%PATH%
set PATH=%DOT%\win\bin;%PATH%
for /F %%p in ('scoop prefix z.lua') do set PATH=%PATH%;%%p

