class User {
  final int id;
  final String name;
  final String email;

  User(this.id, {
    this.name = '',
    this.email = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return User(
      json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}