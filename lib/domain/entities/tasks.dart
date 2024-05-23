class Task {
  final String uuid;
  String title;
  String description;
  String state;
  String priority;
  String notificationTime;
  String userUUID;

  Task({
    required this.uuid,
    required this.title,
    required this.description,
    required this.state,
    required this.priority,
    required this.notificationTime,
    required this.userUUID
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      uuid: json['uuid'],
      title: json['title'],
      description: json['description'],
      state: json['state'],
      priority: json['priority'],
      notificationTime: json['notificationTime'],
      userUUID: json['userUUID'],
    );
  }
}
