Item {
  // вход
  property var file: ""   // Файл откуда грузить данные
  property var skip: ""   // Если встречается подстрока skip - пропускаем строку загрузки
  property var revert: false // перевернуть порядок прочитанных строк
  
  // выход
  property var output: [] // 2-мерный массив загруженных значений
  
  function trim1 (str) {
    return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
  }

  function filter( item ) {
    return parseFloat( item );
  }

  id: csv
  
  property var q: {
   if (!file) { output = []; return; }
  
   if (csv.xhr) csv.xhr.abort();

   csv.xhr = loadFile( file, function(data) {
    var lines = data.split("\n");
    var acc = [];
    for (var i=0; i<lines.length; i++) {
      var line = trim1( lines[i] );
      if (skip.length > 0 && line.indexOf(skip) >= 0) continue;
      
      if (line.length == 0) continue;
      var nums = line.split(/\s+/).map( function(f) { var q = filter(f); return isnan(q) ? f : q } );
      if (nums.length > 0) {
        // Фишка. Если еще не прочитали толком данных, а строка начинается с не-числа - пропускаем ее.
        // так мы отсекаем всякие заголовки в начале файла
        if (acc.length == 0 && isnan(nums[0])) continue; 
        
        acc.push( nums );
        
      }
    }
    output = revert ? acc.reverse() : acc;
    csv.xhr = null;
    },
    function (err) { 
      csv.xhr = null; 
    }
  )

  } // q
  
  /*
,
    function() {  // on error
      output = [];
    }  
  */
  
  /*
  function getcolumnsf(columns) {
    var res = [];
    console.log("getcolumnsf of ",columns,data);
    for (var i=0; i<data.length; i++)
    for (var j=0; j<columns.length; j++)
      res.push( data[i][j] );
    console.log(res);
    return res;
  }
  */

}