regedt32 /s cleanreg.reg 
assoc .vl=VisualLanguangeFile
ftype VisualLanguangeFile=C:\vasev\Chromium_Win_Oculus_0.8.0.0\chrome.exe --allow-file-access-from-files %~dp0scene.html?s--%%1
pause