class AppUser {
  final String id;
  final String? name;
  final String email;
  final String password;

  AppUser({required this.id, this.name, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
