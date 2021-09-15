class Worker{
  String _name;
  String _phoneNumber;
  String _email;
  String _job;

  Worker(this._name, this._phoneNumber, this._email, this._job);

  String? get job => _job;

  set job(String? value) {
    _job = value!;
  }

  String? get email => _email;

  set email(String? value) {
    _email = value!;
  }

  String? get phoneNumber => _phoneNumber;

  set phoneNumber(String? value) {
    _phoneNumber = value!;
  }

  String? get name => _name;

  set name(String? value) {
    _name = value!;
  }
}