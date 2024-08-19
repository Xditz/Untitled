class User {
  int? id;
  String email;
  String password;
  String fullName;
  String bio;
  String? photoPath;

  User({this.id, required this.email, required this.password, required this.fullName, this.bio = '', this.photoPath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'fullName': fullName,
      'bio': bio,
      'photoPath': photoPath,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      fullName: map['fullName'],
      bio: map['bio'],
      photoPath: map['photoPath'],
    );
  }
}
