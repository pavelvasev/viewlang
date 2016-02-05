// Вход: input - массив из 3-ек чисел
// Выход: output: массив из 3-ек чисел, где input продублирован, чтобы из отрезков сделать ломаную

Item {
  property var input

  property var output: input ? make(input) : []

  function make (input) {
    var acc = [];
    var ilen = input.length -3;

    for (var i=0; i<ilen; i+=3) {
      acc.push( input[i] );
      acc.push( input[i+1] );
      acc.push( input[i+2] );

      acc.push( input[i  +3] );
      acc.push( input[i+1+3] );
      acc.push( input[i+2+3] );
    }

    return acc;
  }
}