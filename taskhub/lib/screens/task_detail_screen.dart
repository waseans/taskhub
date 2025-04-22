import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final supabase = Supabase.instance.client;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController locationController;
  DateTime? dueDate;
  String priority = 'Medium';
  String colorCode = '#FFC727';
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    titleController = TextEditingController(text: task['title']);
    descriptionController = TextEditingController(text: task['description'] ?? '');
    categoryController = TextEditingController(text: task['category'] ?? '');
    locationController = TextEditingController(text: task['location'] ?? '');
    dueDate = task['due_date'] != null ? DateTime.parse(task['due_date']) : null;
    priority = task['priority'] ?? 'Medium';
    colorCode = task['color_code'] ?? '#FFC727';
    isCompleted = task['is_completed'] ?? false;
  }

  Future<void> updateTask() async {
    await supabase.from('tasks').update({
      'title': titleController.text,
      'description': descriptionController.text,
      'category': categoryController.text,
      'location': locationController.text,
      'priority': priority,
      'due_date': dueDate?.toIso8601String(),
      'color_code': colorCode,
      'is_completed': isCompleted,
    }).eq('id', widget.task['id']);
    Navigator.pop(context, true); // return true if updated
  }

  Future<void> deleteTask() async {
    await supabase.from('tasks').delete().eq('id', widget.task['id']);
    Navigator.pop(context, true); // return true if deleted
  }

  Future<void> pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Task Details", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: deleteTask,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Title", labelStyle: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Description", labelStyle: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: categoryController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Category", labelStyle: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Location", labelStyle: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Priority:", style: TextStyle(color: Colors.white70)),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: priority,
                  dropdownColor: const Color(0xFF2A2A40),
                  style: const TextStyle(color: Colors.white),
                  items: ['Low', 'Medium', 'High'].map((val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => priority = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Due Date:", style: TextStyle(color: Colors.white70)),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: pickDueDate,
                  child: Text(
                    dueDate != null ? DateFormat.yMMMd().format(dueDate!) : "Pick a date",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Completed:", style: TextStyle(color: Colors.white70)),
                Checkbox(
                  value: isCompleted,
                  onChanged: (val) {
                    setState(() => isCompleted = val ?? false);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFC727)),
              onPressed: updateTask,
              child: const Text("Update Task"),
            ),
          ],
        ),
      ),
    );
  }
}
