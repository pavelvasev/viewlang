TextInput {
  property string placeholderText

  onPlaceholderTextChanged: this.dom.firstChild.placeholder = placeholderText;
}