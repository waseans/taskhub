import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskhub/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dtljcenmacoyephrangw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR0bGpjZW5tYWNveWVwaHJhbmd3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUyMzcwMDMsImV4cCI6MjA2MDgxMzAwM30.3UTvegudvHCStPZFqOwSxi6JE-WbOHvst14qqFv7Rqo',
  );

  // Clear previous session on every app start
  await Supabase.instance.client.auth.signOut();

  runApp(const TaskHubApp());
}

class TaskHubApp extends StatelessWidget {
  const TaskHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskHub',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
