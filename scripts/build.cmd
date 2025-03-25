@echo off
rmdir /s /q build
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
%QTDIR%\bin\windeployqt --qmldir .\resources\qml build\Release\framelesswidget.exe