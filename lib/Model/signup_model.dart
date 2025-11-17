class SignUpModel {
  String? username;
  String? email;
  String? password;

  SignUpModel({this.username, this.email, this.password});

  Map<String, dynamic> toJson() {
    return {"username": username, "email": email, "password": password};
  }
}
