// ������������ ����� - ���������� FindLines, ������� ������ �����, � ��������� �� � GetLines, ������� ������
FindLines {
  output: gl.output

  property var output0: go( input, filter )

  GetLines {
    id: gl
    input: parent ? parent.input : []
    lines: parent.output0

  }

}