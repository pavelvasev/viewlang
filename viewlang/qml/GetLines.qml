// вытаскивает строки с заданными номерами
Item {
  // вход
  property var source: parent
  property var input: source ? source.output : [] // 2мерный массив значений csv
  property var lines                              // номера колонок, какие вытащить
  
  // выход
  property var output: getlines( input, lines)  // 2-мерный массив извлеченных данных

  function getlines(data,index) {
    //console.log("Getlines..",data,index);
    var res = [];
    for (var i=0; i<index.length; i++)
      if (data.length > index[i])
        res.push( data[ index[i] ] );
    //console.log(res );
    return res;
  }

}