class User {
  String? id;
  String? email;
  String? name;
  String? phoneNumber;
  String? password;

  User([String? id, String? email, String? name, String? phoneNumber, String? password]) {
    this.id = id;
    this.email = email;
    this.name = name;
    this.phoneNumber = phoneNumber;
    this.password = password;
  }

  factory User.fromJson(Map<String, dynamic> json) => User(json['id'], json['email'], json['name'], json['phone_number']);
}
