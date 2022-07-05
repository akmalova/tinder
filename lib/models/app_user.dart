class AppUser {
  final String id;
  final String name;
  final String login;
  final String password;
  final List<String> likes;
  final List<String> dislikes;
  final String? image;

  AppUser(
      {required this.id,
      required this.name,
      required this.login,
      required this.password,
      required this.likes,
      required this.dislikes,
      required this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'login': login,
      'password': password,
      'likes': likes,
      'dislikes': dislikes,
      'image': image,
    };
  }
}
