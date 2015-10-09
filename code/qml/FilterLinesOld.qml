// классическая схема - используем FindLines, получим номера строк, и передадим их в GetLines, получим строки
FindLines {
  output: gl.output

  property var output0: go( input, filter )

  GetLines {
    id: gl
    input: parent ? parent.input : []
    lines: parent.output0

  }

}