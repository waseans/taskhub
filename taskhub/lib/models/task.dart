class Task {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final bool isCompleted;
  final String? priority;
  final DateTime? dueDate;
  final String? category;
  final String? location;
  final String? colorCode;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority,
    this.dueDate,
    this.category,
    this.location,
    this.colorCode,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['is_completed'],
      priority: map['priority'],
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      category: map['category'],
      location: map['location'],
      colorCode: map['color_code'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'priority': priority,
      'due_date': dueDate?.toIso8601String(),
      'category': category,
      'location': location,
      'color_code': colorCode,
    };
  }
}
