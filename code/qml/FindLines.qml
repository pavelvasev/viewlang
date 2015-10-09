// выискивает номера строк по критерию
Item {
  // вход
  property var source: parent
  property var input: source ? source.output : [] // 2мерный массив значений csv

  function filter( line ) {
    return true;
  }
  
  // выход
  property var output: go( input )  // 1-мерный массив номеров подошедших строк

  function go(data) {

    var res = [];
    for (var i=0; i<data.length; i++)
      if (filter(data[i])) res.push( i );

    return res;
  }

}