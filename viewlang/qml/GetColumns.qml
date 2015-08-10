Item {
  // вход
  property var source: parent
  property var input: source ? source.output : [] // 2мерный массив значений csv
  property var columns                            // номера колонок, какие вытащить
  
  // выход
  property var output: getcolumnsf( input, columns )  // 1-мерный массив извлеченных данных

  function getcolumnsf(data,columns) {
    var res = [];
//    console.log("GetColumns of ",columns,data,"parent=",parent);
    for (var i=0; i<data.length; i++)
    for (var j=0; j<columns.length; j++)
      res.push( data[i][ columns[j] ] );
//    console.log(res);
    return res;
  }

}