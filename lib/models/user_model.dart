class User {
  String firstname;
  String lastname;
  String email;
  String? uid;
  String birthday;
  String? username;
  String? country;
  String? phoneNumber;

  User(
      {required this.firstname,
      required this.lastname,
      required this.email,
      this.uid,
      required this.birthday,
      this.username,
      this.country,
      this.phoneNumber});

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "uid": uid,
        "email": email,
        "birthday": birthday,
        "username": username,
        "country": country,
        "phone": phoneNumber,
      };
}
