Column {
    GroupBox {
        title: "ComboBox test"

        Column {
            spacing: 5

            Row {
                spacing:5
                ComboBox {
                    id: select
                    model: ['bla','bla2','bla3', 'bla4', 'bla5', 'bla6', 'bla7']
                    currentIndex: 0
                }

                Text {
                    text: "currentIndex="+select.currentIndex + ' currentText=' + select.currentText
                }
            }

            Button {
                id: btn3
                text: "newModel"
                onClicked: select.model = ['olo','olo2','olo3', 'olo5']
            }

            Button {
                id: btn4
                text: "change currentIndex to 3"
                width: 150
                onClicked: select.currentIndex = 3
            }

        } // column

    } // groupbox for combo test

    GroupBox {
        title: "ComboBox test 2"
        width: 400

        ComboBox {

            id: select2
            model: ['bla','bla2','bla3', 'bla4', 'bla5', 'bla6', 'bla7']
            height: 150
            width: 250
            size: 3
        }

    }

}        
