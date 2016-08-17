// Вход: input1 iput2 - массивы из 3-ек чисел
// Выход: output: массив из 3-ек чисел, где input1 и input2 совмещены - поочередно вставлены тройки
// но вторая тройка - есть сумма первой и второй

Item {
  property var input1
  property var input2

  property var output: input1 && input2 ? make(input1,input2) : []

  function make (input1, input2) {
    var acc = [];
    if (input1.length != input2.length) return [];

    var ilen = input1.length;

    for (var i=0; i<ilen; i+=3) {
      acc.push( input1[i] );
      acc.push( input1[i+1] );
      acc.push( input1[i+2] );

      acc.push( input1[i] + input2[i] );
      acc.push( input1[i+1] + input2[i+1] );
      acc.push( input1[i+2] + input2[i+2] );
    }

    return acc;
  }

}