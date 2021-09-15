class Note{

  String _note;
  String _createdAt;
  String _description;

  Note(this._note, this._description, this._createdAt);

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get createdAt => _createdAt;

  set createdAt(String value) {
    _createdAt = value;
  }

  String get note => _note;

  set note(String value) {
    _note = value;
  }
}