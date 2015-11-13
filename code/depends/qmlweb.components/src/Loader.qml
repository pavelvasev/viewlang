// http://doc.qt.io/qt-5/qml-qtquick-loader.html

/* TODO 
   - think on sizing behaviour. For now, size of item is set to loader sizes once, on load. Maybe it is good to create binding from loader sizes.
   - load from sourceComponent. BTW need to implement Component in qmlweb
   - "active" prop is changing sourceComponent. Fix this.
*/    

Item {
    id: loader

    property string source
    property bool   active: true

    implicitWidth: loader.item ? loader.item.width : 0
    implicitHeight: {
        var v = loader.item ? loader.item.height : 0
        //console.log(loader.item);
        //console.log("loadr implicit h=",v,source, "and own height=",loader.height);
        return v;
    }

    signal loaded();

    function respondToSourceChange() {
        //console.log("loader creates component for source=",source);
        // __executionContext
        var context = loader.$properties["source"].componentScope;
        
        // little HACK. lookup in loaded qmldirs
        var qdirInfo = engine.qmldirs[ source ];
        
        if (qdirInfo)
            sourceComponent = Qt.createComponent( "@" + qdirInfo.url, context );
        else
            sourceComponent = Qt.createComponent( source.indexOf(".") > 0 ? source : source + ".qml",context );  // e.g. if source contains 'dot', load as is; if not - add .qml to it.

        if (!sourceComponent) {
            console.error("Loader.qml: failed to load component from source=",source );
        }
    }

    // with timeoutMode = true, Loader performs loading after small timeout
    // with timeoutMode = false, Loader loads (e.g. creates component) immediately
    property bool timeoutMode: true

    onSourceChanged: {
        if (loader.timeoutId && timeoutMode) {
            clearTimeout(loader.timeoutId);
            loader.timeoutId=null;
            //console.log("%%%%%%%%%%%%%%%%%%%%%%%% timeout cleared");
        }

        if (source) {
            if (active) {

                if (!timeoutMode)
                    respondToSourceChange();
                else
                    loader.timeoutId=setTimeout( function() {
                        respondToSourceChange();
                        loader.timeoutId=null;
                    }, 1 ); //setTimeout

            }
            else
                sourceComponent = null;
        }
        else
            sourceComponent = null;
    }

    onActiveChanged: {
        if (source)
            sourceChanged();
        else
            sourceComponentChanged();
    }

    property var sourceComponent

    property var item

    onSourceComponentChanged: {
        //console.log( "@@@LOADER id=",this._uniqueId,"SourceComponentChanged, sourceComponent=",sourceComponent);
        //console.trace();

        if (item) {
            //console.log("deleting item...");
            loader.item.$delete();
            //item.parent = undefined;
            //delete loader.item; if we call delete, it will destroy property, including getters/setters, and not the object.
            loader.item = undefined;
        }

        if (!sourceComponent || !active) {
            //console.log("@@@LOADER not active or no source component, exiing");
            return;
        }
        //console.log("@@@LOADER create object");
        var it = sourceComponent.createObject(loader);
        //console.log("@@@LOADER created object");

        if (!it) {
            console.error("failed to create object for component source=",source );
            return;
        }

        // Alter objects context to the outer context
        // no need - it uses component context which is ok
        // it.$context = __executionContext;

        //if (meta.object.id)
        //    meta.context[meta.object.id] = item;

        // keep path in item for probale use it later in Qt.resolvedUrl
        // ? it.$context["$basePath"] = engine.$basePath; //gut

        // Apply properties (Bindings won't get evaluated, yet)
        // applyProperties(meta.object, it, it, meta.context);
        // видимо сюда пойдут properties

        var recursionCheckItem = loader.item;

        //console.log("assigning parent to loaded item. item=",it);
        // must keep op state init? while assigning parent..
        // if bugs will appear, maybe call layout children etc?...
        var oldState = engine.operationState;
        engine.operationState = QMLOperationState.Init;

        it.parent = loader;
        loader.childrenChanged();

        engine.operationState = oldState;

        // TODO debug this. Without check to Init, Completed sometimes called twice.. But is this check correct?
        if (engine.operationState !== QMLOperationState.Init && engine.operationState !== QMLOperationState.Idle) {
            // We don't call those on first creation, as they will be called
            // by the regular creation-procedures at the right time.
            //console.log("@@@LOADER inits props");
            engine.$initializePropertyBindings();
            engine.callCompletedSignals();
            //console.log("@@@LOADER inited props and compl signal");
            //callOnCompleted(it);
        }
        else {
            //console.log("@@@LOADER did not call init prop bindings or completes, because engine.operationState=",engine.operationState);
        }

        if (recursionCheckItem !== loader.item) {
            // ahha.. recursion...

            it.$delete();
            it = undefined;
            //console.log("loader exited due to recursion");
            return;
        }

        //console.log("@@@LOADER setting item to loader loader.source=",loader.source, "it=",it );
        //debugger;
        loader.item = it;

        // see http://doc.qt.io/qt-5/qml-qtquick-loader.html Loader sizing behavior

        //  If an explicit size is not specified for the Loader, the Loader is automatically resized to the size of the loaded item once the component is loaded.
        //  If the size of the Loader is specified explicitly by setting the width, height or by anchoring, the loaded item will be resized to the size of the Loader.

        //console.log("@@@LOADER loader.$isUsingImplicitWidth=",loader.$isUsingImplicitWidth, "loader.$isUsingImplicitHeight=",loader.$isUsingImplicitHeight,"width=",width,source );
        if (!loader.$isUsingImplicitWidth)
        {
            //console.log("setting loader.item.width = loader.width",loader.width);
            loader.item.width = loader.width;
        }
        //console.log( "loader.$isUsingImplicitHeight = ",loader.$isUsingImplicitHeight)
        if (!loader.$isUsingImplicitHeight)
        {
            //console.log("setting loader.item.height = loader.height",loader.height);
            loader.item.height = loader.height;
        }

        loaded();
    }

    /*
    function callOnCompleted(child) {
        child.Component.completed();
        var arr = child.children.slice(0); // we need to clone array. because it may change during Component.OnCompleted evaluation, if some control will decide to change it's parent
        for (var i = 0; i < arr.length; i++)
            callOnCompleted(arr[i]);
    }
    */


}
