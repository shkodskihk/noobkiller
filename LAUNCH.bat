@echo off
cd %~dp0\lua
:begin
lua core.lua
goto begin
