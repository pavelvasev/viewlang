// Создание хэш-параметра с учетом пути scope
ParamUrlHashing {
  id: puh

  property alias scopeCalc: scopeNameCalc
  
  paramName: scopeNameCalc.mapAndCount2( scopeNameCalc.scopeName + puh.name, puh )
  //onParamNameChanged: console.log("*********************** paramName=",scopeName);

  ScopeCalculator {
    id: scopeNameCalc
    //onScopeNameChanged: console.log("*********************** scopeName=",scopeName);
  }

}
