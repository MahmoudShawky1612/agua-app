class UserModel {
  final int id;
  final String username;
  final String gender;

  UserModel({
    required this.id,
    required this.username,
    required this.gender,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      gender: json['gender'],
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'gender': gender,
    };
  }
}
