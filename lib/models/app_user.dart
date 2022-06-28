class AppUser {
  String id;
  final String name;
  String login;
  String password;
  final List<String> likes;
  final List<String> dislikes;

  AppUser(
      {required this.id,
      required this.name,
      required this.login,
      required this.password,
      required this.likes,
      required this.dislikes});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'login': login,
      'password': password,
      'likes': likes,
      'dislikes': dislikes,
    };
  }
}
