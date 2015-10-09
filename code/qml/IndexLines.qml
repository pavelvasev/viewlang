// создает индекс по строкам
Item {
  // вход
  property var source: parent
  property var input: source ? source.output : [] // 2мерный массив значений csv

  function filter( line,acc,i,len ) {
    return i;
  }
  
  // выход
  property var output: go( input )  // 2-мерный массив извлеченных данных

  function go(data) {

    var res = {};
    var acc = {};
    var len = data.length;

    for (var i=0; i<len; i++) {

      var r = filter(data[i], acc, i, len );
      if (!res[r]) res[r] = [];
      res[r].push( data[i] );
    }

    return res;
  }

}