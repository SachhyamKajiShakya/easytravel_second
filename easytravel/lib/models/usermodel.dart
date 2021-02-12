class User {
  String email;
  String username;
  String password;
  String password2;
  String name;
  String phone;

  User({
    this.email,
    this.username,
    this.password,
    this.password2,
    this.name,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      password2: json['password2'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
    );
  }
}

class UserLogin {
  String email;
  String password;
  String token;

  UserLogin({this.token, this.email, this.password});

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      email: json['email'] as String,
      password: json['password'] as String,
      token: json['token'] as String,
    );
  }
}
