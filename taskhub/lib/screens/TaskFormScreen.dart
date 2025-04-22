import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  String title = '';
  String? description;
  String? priority = 'Medium';
  DateTime? dueDate;
  String? category;
  String? location;
  String? colorCode = '#FFC727';

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final response = await _supabase.from('tasks').insert({
      'user_id': user.id,
      'title': title,
      'description': description,
      'priority': priority,
      'due_date': dueDate?.toIso8601String(),
      'category': category,
      'location': location,
      'color_code': colorCode,
    });

    if (response.error == null) {
      Navigator.pop(context, true); // Return to previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    }
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
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
        title: const Text('Add Task', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInputField(
                label: 'Title',
                onSaved: (val) => title = val!,
                validator: (val) => val!.isEmpty ? 'Enter a title' : null,
              ),
              _buildInputField(
                label: 'Description',
                onSaved: (val) => description = val,
                maxLines: 3,
              ),
              _buildDropdown(
                label: 'Priority',
                value: priority,
                items: ['Low', 'Medium', 'High'],
                onChanged: (val) => setState(() => priority = val),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due Date', style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  dueDate != null
                      ? DateFormat.yMMMd().format(dueDate!)
                      : 'No date selected',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: _pickDueDate,
                ),
              ),
              _buildInputField(
                label: 'Category',
                onSaved: (val) => category = val,
              ),
              _buildInputField(
                label: 'Location',
                onSaved: (val) => location = val,
              ),
              _buildInputField(
                label: 'Color Code (hex)',
                onSaved: (val) => colorCode = val,
                initialValue: '#FFC727',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC727),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    String? initialValue,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        initialValue: initialValue,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF2A2A40),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF2A2A40),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            dropdownColor: const Color(0xFF2A2A40),
            style: const TextStyle(color: Colors.white),
            onChanged: onChanged,
            items: items
                .map((item) =>
                    DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
          ),
        ),
      ),
    );
  }
}
