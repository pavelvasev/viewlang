# Viewlang

Viewlang is a 3d visualization web framework based on Qmlweb. It uses WebGL for rendering.

## Online-editor
http://viewlang.ru/code/c.html

## Online-viewer
http://viewlang.ru/code/scene.html

## Local setup (windows)

1. Run as administrator
```
code/setup_vl_assoc.cmd
// This will associate *.vl files with Chrome browser. Your `chrome.exe` should be in `PATH`.
```

2. Configure your Chrome shortcut by adding command line flag `--allow-file-access-from-files`.
Then restart chrome (if it was running).

After setup, you may run viewlang *.vl files by hitting Enter.

## Local setup (linux)
Sorry no instructions at the moment. Some ideas:

1. Try to reproduce windows setup.
2. Run local static webserver and open ./code/scene.html there.

## Examples
Located in ./examples

## How to make a scene

Create file `somename.vl` with scene content, for example:
```
Scene {
  Points {
    positions: [0,0,0, 1,1,1, 2,2,2 ]
  }
}
```
and run that file by hitting enter key.

## How to debug
1. Errors are written to developers console of the browser, Ctrl+Shift+J.
2. If you changed scene file - then reload page in browser.

(с) 2015-2016 Pavel Vasev
