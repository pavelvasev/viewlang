regedt32 /s cleanreg.reg 
assoc .vl=VisualLanguangeFile
ftype VisualLanguangeFile=chrome --allow-file-access-from-files %~dp0scene.html?s--file://%%1
assoc .qml=VisualLanguangeFileQml
ftype VisualLanguangeFileQml=chrome --allow-file-access-from-files %~dp0scene.html?s--file://%%1
pause