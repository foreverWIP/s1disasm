@echo off
%~dp0..\asw\asw -xx -n -q -A -L -U -E -i . sonic
%~dp0..\asw\p2bin sonic.p s1built.bin -r $000000-$0FFFFF
%~dp0..\asw\flip s1built.bin %~dp0..\mame\roms\fatfury2\047-p1.p1