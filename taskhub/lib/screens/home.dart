import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'TaskFormScreen.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> tasks = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final userId = supabase.auth.currentUser?.id;
    final response = await supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    setState(() {
      tasks = response;
    });
  }

  Future<void> deleteTask(String id) async {
    await supabase.from('tasks').delete().eq('id', id);
    fetchTasks();
  }

  void openAddTaskForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TaskFormScreen()),
    ).then((_) {
      fetchTasks(); // refresh after form submission
    });
  }

  void _onBottomNavTapped(int index) {
    if (index == 2) {
      // Add button tapped
      openAddTaskForm();
    } else {
      setState(() {
        _selectedIndex = index;
        // Future: Add navigation for other tabs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('TaskHub', style: TextStyle(color: Colors.white)),
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text("No tasks yet", style: TextStyle(color: Colors.white70)))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final isCompleted = task['is_completed'] ?? false;
                final dueDate = task['due_date'] != null
                    ? DateTime.tryParse(task['due_date'])
                    : null;
                final priority = task['priority'] ?? "Medium";

                return Dismissible(
                  key: Key(task['id']),
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => deleteTask(task['id']),
                  child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskDetailScreen(task: task),
                        ),
                      );
                      if (result == true) {
                        fetchTasks();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isCompleted
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: isCompleted
                                    ? Colors.green
                                    : Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  task['title'] ?? '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          if (task['description'] != null &&
                              task['description']
                                  .toString()
                                  .trim()
                                  .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(task['description'],
                                  style: const TextStyle(color: Colors.white70)),
                            ),
                          Row(
                            children: [
                              if (dueDate != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8.0, right: 16),
                                  child: Text(
                                    "Due: ${DateFormat.yMMMd().format(dueDate)}",
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 12),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Priority: $priority",
                                  style: const TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        backgroundColor: const Color(0xFF2A2A40),
        selectedItemColor: const Color(0xFFFFC727), // bright yellow
        unselectedItemColor: Colors.white, // better visibility
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notify"),
        ],
      ),
    );
  }
}
