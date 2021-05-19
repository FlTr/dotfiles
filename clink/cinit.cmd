@echo off

:: Start the goodness
call clink inject --quiet

:: Setup aliases
%GIT_INSTALL_ROOT%\usr\bin\bash --login %DOT%\clink\collect-aliases.sh
doskey /macrofile=%DOT%\clink\aliases

:: Setup PATH
:: TODO

:: Clean title
title cmd
