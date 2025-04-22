import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';

class TaskService {
  final supabase = Supabase.instance.client;

  Future<List<Task>> fetchTasks() async {
    final response = await supabase
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    if (response == null || response is! List) return [];

    return response.map((task) => Task.fromMap(task)).toList();
  }

  Future<void> addTask(Task task) async {
    await supabase.from('tasks').insert(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await supabase.from('tasks').delete().eq('id', id);
  }

  Future<void> toggleTaskStatus(String id, bool isCompleted) async {
    await supabase.from('tasks').update({'is_completed': isCompleted}).eq('id', id);
  }
}
