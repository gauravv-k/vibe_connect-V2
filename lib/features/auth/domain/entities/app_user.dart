class AppUser {
  final String Uid;
  final String email;
  final String name;

  AppUser({
    required this.Uid,
    required this.email,
    required this.name,
  });

    Map<String, dynamic> toJson() {
    return {
      'Uid': Uid,
      'email': email,
      'name': name,
    };
  }
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      Uid: json['Uid'],
      email: json['email'],
      name: json['name'],
    );
  }
}
