import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, dynamic>> fakeNotifications = const [
    {
      'title': 'Task Completed',
      'message': 'You finished “Buy groceries”',
      'icon': Icons.check_circle,
      'time': 'Just now',
    },
    {
      'title': 'Reminder',
      'message': 'Don’t forget to submit project report',
      'icon': Icons.notifications_active,
      'time': '1 hour ago',
    },
    {
      'title': 'New Feature',
      'message': 'You can now set recurring tasks!',
      'icon': Icons.new_releases,
      'time': 'Yesterday',
    },
    {
      'title': 'Task Due',
      'message': '“Team meeting” is due in 30 minutes',
      'icon': Icons.schedule,
      'time': '2 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: fakeNotifications.length,
        itemBuilder: (context, index) {
          final notif = fakeNotifications[index];
          return Card(
            color: const Color(0xFF2A2A40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(notif['icon'], color: const Color(0xFFFFC727)),
              title: Text(
                notif['title'],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                notif['message'],
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Text(
                notif['time'],
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tapped on "${notif['title']}"'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
