Scene {
    id: appender
    property var apps: [] // классы (строками) или qml-файлы (строками-урлями)

    property var appset: [] // здесь список загруженных программ
    property var appDisabled: [] // программа включена-выключена

    ParamUrlHashing {
        target: appender
        property: "appset"
        name: "appender-appset"
    }

    property alias text: bt.text

    GroupBox {
        title: "loaded"
        property var tag: "left"

        Column { //loaded apps
            Button {
                id: bt

                text: "Добавить объект"
                onClicked: d1.open()
                width: 120
            }

            Repeater {
                model: appset.length
                Row {
                    CheckBoxParam {
                        tag: null
                        text: appset[ index ]
                        guid: "app-disabled-"+index
                        checked: !appDisabled[ index ]
                        width: 160
                        onCheckedChanged: {
                            appDisabled[ index ] = !checked;
                            appender.appDisabledChanged();
                        }
                    }
                    Text {

                    }
                } // row
            } // repeater
        } //column
    } // groupbox of added apps


    SimpleDialog {
        id: d1
        title: bt.text

        Row {
            spacing: 5
            Column {
                spacing:2
                Repeater {
                    model: apps.length
                    Button {
                        text: apps[ index ]
                        onClicked: {
                            appset.push( apps[ index ] );
                            appender.appsetChanged();
                            d1.close();
                        }
                    } //bt
                } //repeater
            } // column

        } // row

    } //dlg

    signal appLoaded( object app );

    Repeater {
        model: appset.length
        Loader {
            source: appset[ index ]
            anchors.fill: parent
            id: ldr
            onLoaded: {
                console.log("!!!!!!!!!!!!!!! i assign scope name to app");
                ldr.item.scopeName = ldr.source;
                appender.refineAll();
                appender.appLoaded( ldr.item );
            }
            Binding {
                target: ldr.item
                property: "visible"
                value: !appDisabled[ index ]
            }
            Binding {
                target: ldr.item
                property: "enabled"
                value: !appDisabled[ index ]
            }
            // active?
        }
    }

}
