import components.csv_loader 
import components.show_points

ShowPointsApp {
  id: app
  positions: flat.output
  mode: 1
  color: [0.2,0.2,0.2]

  CsvLoaderApp {
    text: "Укажите файл данных CSV"
    file: Qt.resolvedUrl("coord.txt")
    Flatten {
      id: flat
    }
    cpriority: 4
    ctag: app.ctag
  }

}