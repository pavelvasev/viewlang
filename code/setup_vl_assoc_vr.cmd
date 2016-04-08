regedt32 /s cleanreg.reg 
assoc .vl=VisualLanguangeFile
ftype VisualLanguangeFile=C:\vasev\Chrome-bin\chrome.exe --enable-logging --allow-file-access-from-files %~dp0scene.html?s--%%1
rem --enable-logging --v=1 почемуто последний аргумент вышыбает фтайп винды..
pause