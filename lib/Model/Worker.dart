class Worker{
  late String _name;
  late String _phoneNumber;
  late String _email;
  late String _job;

  Worker(this._name, this._phoneNumber, this._email, this._job);
  Worker.fromSnapshot(Map<String, dynamic> data){
    this._name=data['workerName'];
    this._email=data['workerEmail'];
    this._job=data['workerJob'];
    this._phoneNumber=data['workerPhoneNumber'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map={
      'workerName':this._name,
      'workerEmail':this._email,
      'workerJob':this._job,
      'workerPhoneNumber':this._phoneNumber
    };
    return map;
  }

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