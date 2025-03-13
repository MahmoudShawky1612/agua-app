class UserModel {
  final int id;
  final String username;
  final String gender;
  final int totalDrinks;
  final int onTimeDrinks;
  final int accuracy;

  UserModel({
    required this.id,
    required this.username,
    required this.gender,
    required this.totalDrinks,
    required this.accuracy,
    required this.onTimeDrinks,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      gender: json['gender'],
      totalDrinks: json['totalDrinks'],
      accuracy: json['accuracy'],
      onTimeDrinks: json['onTimeDrinks'],
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'gender': gender,
      'totalDrinks': totalDrinks,
      'accuracy': accuracy,
      'onTimeDrinks': onTimeDrinks,
    };
  }
}
