// Вычисляет глобальное имя переменных для использования в урлях и в osc и т.д.

// Выход 1: scopeName - строка, текущий полный scope, сделанный уникальным (с учетом возможного дублирования).

// Вход 2: name
// Выход 2: globalName - имя с добавлением scopeName и с учетом повторного возможного дублирования (например когда scopeName пуст).

Item {
  id: it

  property var target: parent

  property var name
  property var globalName: name ? it.mapAndCount2( it.scopeName + name, it.target ) : ""
  property var text
  property var globalText: text ? it.mapAndCount2( it.scopeName + text, it.target ) : ""  

  property var scopeName: {
    var f = target;

    var chain = [];
    while (f) {
      // если указана scopeName - прицепляем ее слева. 
      if (typeof(f.scopeName) !== "undefined" && f.scopeName.length && f.scopeName.length > 0) {
        chain.unshift( f );
        if (f.scopeNameIsFinal) break;
      }
 
      if (typeof(f.oldSpaceParent) !== "undefined")
        f = f.oldSpaceParent;
      else
        f = f.parent;
    }

    // ok we have chain
    var r = "";
    for (var i=0; i<chain.length; i++) {
      r = r + chain[i].scopeName + "/";
      r = mapAndCount( r,chain[i] );
    }
    
    //console.log("scope assigned",r );
    return r;
  }
  
  function mapAndCount( str, obj )
  {
    var count = uniqObjectCounter( str, obj );
    if (count == 1) return str;
    return str + count + "/";
  }

  function mapAndCount2( str, obj )
  {
    var count = uniqObjectCounter( str, obj );
    if (count == 1) return str;
    return str + "-" + count;
  }
  
  function uniqObjectCounter( str, obj ) {
    if (obj.enableScopeDuplicated) return 1;
  
    if (typeof(window.uniqObjectCounterArr) === "undefined") window.uniqObjectCounterArr = {};
    if (!window.uniqObjectCounterArr.hasOwnProperty(str)) window.uniqObjectCounterArr[str] = [];

    var counters = window.uniqObjectCounterArr[str];
    var index = counters.indexOf(obj);
    if (index >=0) return (index+1);
    
    // итак объект еще не учтен
    counters.push(obj);

    var removeObjFromCount = function() {
      var idx = counters.indexOf(obj);
      if (idx >= 0) counters.splice( idx, 1 );
//      console.log("removed obj from scope calc",str);
    }
    
    // когда объект будет удаляться, мы дОлжны уменьшить счетчик.. хех.. а не не хех, все ок
    if (obj && obj.Component && obj.Component.destruction && obj.Component.destruction.connect) 
      obj.Component.destruction.connect( it,removeObjFromCount );
    
    return counters.length;
  }
  
}