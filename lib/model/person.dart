class Person {
  String name;
  String email;
  String picUrl;
  String dob;
  String location;
  String gender;
  String uid;
  Person({
    this.name,
    this.email,
    this.picUrl,
    this.dob,
    this.location,
    this.gender,
    this.uid,
  });


  @override
  String toString() {
    return 'Person(name: $name, email: $email, picUrl: $picUrl, dob: $dob, location: $location, gender: $gender, uid: $uid)';
  }
}
