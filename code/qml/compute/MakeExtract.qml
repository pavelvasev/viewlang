// Вход: input offset count
// Выход: подмассив

Item {
  property var input
  property var offset: 0
  property var count: 3

  property var output: input ? make(input, offset, count) : []

  function make (input, offset, count) {
    var acc = [];
    if (offset < 0) return [];

    var ilen = input.length;
    var upto = Math.min( ilen, offset+count )

    for (var i=offset; i<upto; i++) {
      acc.push( input[i] );
    }

    return acc;
  }

}