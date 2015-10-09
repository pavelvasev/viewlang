SceneObject {
    id: ttt

    property var sources
    onSourcesChanged: loadJsonSources(sources);

    Component.onCompleted: {
      //console.log('miimimi',sources);//,ttt.parent,ttt.source,ttt );
      loadJsonSources(sources);
    }

    function loadJsonSources(srcs)
    {
        var it = ttt.source;
        //debugger;
        console.log("LoadJsonUp::loadJsonSources...",srcs,"parent=",it);
        if (!srcs || srcs.length == 0 || !it) return;

        if (!Array.isArray(srcs)) srcs = [srcs];

        for (var i=0; i<srcs.length; i++) {
            var src = srcs[i];
            if (!src || src.length == 0) continue;
            loadFile(src, function(res) {
                var p = parseJson(res);
                //console.log(p);

                for (k in p) {
                    if (p.hasOwnProperty(k)) {

                        it[k] = p[k];
                    }
                }

            } ); //loadfile

        } // for

    }

}
