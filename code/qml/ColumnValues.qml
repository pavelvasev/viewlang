// Вычисление __различных__ значений заданной колонки
Item {
  // вход
  property var source: parent
  property var input: source ? source.output : [] // 2мерный массив значений csv
  property var column                             // номер колонки
  
  // выход
  property var output: go( input, column )  // 1-мерный массив извлеченных данных

  function go(data,col) {
    var h = {}
    for (var i=0; i<data.length; i++)
      h[ data[i][ col ] ] = 1;
    var vals = [];
    for (val in h) vals.push( parseFloat(val) );

    return vals.sort(function(a,b) { return a - b;});
  }

}