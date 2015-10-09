import QtQuick 2.3
Text {
  text: {
    return "the foo = "+foo;
  }
  property var q: {
    console.log("in eval q, foo=",foo );
    return 1;
  }
}
