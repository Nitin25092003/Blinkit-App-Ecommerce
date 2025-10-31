class User {
  int? id;
  String name;
  String email;
  String password;
  String? profileImagePath; // local file path or asset path

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profileImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profileImagePath': profileImagePath,
    };
  }

  factory User.fromMap(Map<String, dynamic> m) {
    return User(
      id: m['id'] as int?,
      name: m['name'] as String,
      email: m['email'] as String,
      password: m['password'] as String,
      profileImagePath: m['profileImagePath'] as String?,
    );
  }
}
