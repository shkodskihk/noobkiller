@echo off
cd "%~dp0\lua"
:begin
..\bin\luajit.exe core.lua
goto begin
