// выбирает строки по критерию
// скоростная версия
Item {
  // вход
  property var source: parent
  property var input: source ? source.output : [] // 2мерный массив значений csv

  property var start: 0
  property var step: 1

  function filter( line,acc,i,len ) {
    return line;
  }
  
  // выход
  property var output: go( input )  // 2-мерный массив извлеченных данных

  function go(data) {

    var res = [];
    var acc = {};
    var len = data.length;
    
    var sstart = start;
    var sstep = step;
    for (var i=sstart; i<len; i+=sstep) {

      var r = filter(data[i], acc, i, len );
      
      if (!r) continue;
      if (r === true) res.push( data[i] ); else res.push( r ); // если вернули true то положить всю строку. а так обычно - кладем то что вернули
    }

    return res;
  }

}