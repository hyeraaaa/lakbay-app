class Account {
  final int id;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  Account({
    required this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
