@echo off
cd "%~dp0\lua"
:begin
..\bin\lua.exe core.lua
goto begin
