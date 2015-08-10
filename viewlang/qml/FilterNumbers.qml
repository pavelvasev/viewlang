// проходит по всем числам N-мерного массива и набирает аккумулятор
Item {
  // вход
  property var source: parent
  property var input: source ? source.output : [] // N-мерный массив значений csv

  property var start: 0
  property var step: 1

  function filter( num,acc ) {
    return num;
  }
  
  // выход
  property var output: go( input )  // значение аккумулятора

  function go(data,initacc) {
    var acc = initacc || [];

    if (!data) return acc;

    var len = data.length;

    var sstart = start;
    var sstep = step;
    for (var i=sstart; i<len; i+=sstep) {

      if(data[i].constructor == Array) {
        go( data[i], acc );
        continue;
      }
      
      filter(data[i], acc );
    }

    return acc;
  }

}