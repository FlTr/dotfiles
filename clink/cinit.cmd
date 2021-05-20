@echo off

:: Start the goodness
call clink inject --quiet

:: Setup aliases
"%GIT_INSTALL_ROOT%\usr\bin\bash" --login %DOT%\clink\collect-aliases.sh
doskey /macrofile=%DOT%\clink\aliases

:: Setup PATH
for /F %%p in ('scoop prefix python') do set PATH=%PATH%;%%p\Scripts
for /F %%p in ('scoop prefix z.lua') do set PATH=%PATH%;%%p

:: ENV
set _ZL_NO_CHECK=1

:: Clean title
title cmd
