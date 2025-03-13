class DrankModel {
  final int id;
  final int userId;
  final String day;
  final int time;
  final bool isOnTime;
  final int litre;

  DrankModel({
    required this.id,
    required this.userId,
    required this.day,
    required this.time,
    required this.isOnTime,
    required this.litre,
  });

  // Factory constructor to create an instance from JSON
  factory DrankModel.fromJson(Map<String, dynamic> json) {
    return DrankModel(
      id: json['id'],
      userId: json['userId'],
      day: json['day'],
      time: json['time'],
      isOnTime: json['isOnTime'],
      litre: json['Litre'], // Ensure consistency with API key
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'day': day,
      'time': time,
      'isOnTime': isOnTime,
      'Litre': litre, // Ensure consistency with API key
    };
  }
}