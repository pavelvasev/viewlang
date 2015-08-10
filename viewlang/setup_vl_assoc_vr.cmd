regedt32 /s cleanreg.reg 
assoc .vl=VisualLanguangeFile
ftype VisualLanguangeFile=D:\chrome-web-vr\Chrome-bin\chrome.exe --allow-file-access-from-files %~dp0scene.html?s--%%1
pause