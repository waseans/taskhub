import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {"text": "Hey! 👋", "isUser": false},
      {"text": "Hi there! How's the task going?", "isUser": true},
      {"text": "Pretty good. Almost done!", "isUser": false},
      {"text": "Awesome 😄", "isUser": true},
      {"text": "Let me know if you need help.", "isUser": false},
      {"text": "Sure, thanks!", "isUser": true},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text("Chat", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['isUser']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: message['isUser']
                          ? const Color(0xFFFFC727)
                          : const Color(0xFF2A2A40),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: message['isUser']
                            ? Colors.black
                            : Colors.white70,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(color: Colors.white12),
          Container(
            color: const Color(0xFF2A2A40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Colors.white),
                      enabled: false, // Disable input (dummy)
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.send, color: Colors.white38),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
