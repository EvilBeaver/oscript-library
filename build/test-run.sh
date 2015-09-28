#!/bin/sh
@echo off
pushd %~dp0\..\tests
chcp 1251 >nul
oscript finder.os
popd