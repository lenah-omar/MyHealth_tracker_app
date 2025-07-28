import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final TextEditingController _reminderController = TextEditingController();
  List<String> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _reminders = prefs.getStringList('reminders') ?? [];
    });
  }

  Future<void> _addReminder() async {
    if (_reminderController.text.isEmpty) return;

    setState(() {
      _reminders.add(_reminderController.text);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('reminders', _reminders);
    _reminderController.clear();
  }

  Future<void> _deleteReminder(int index) async {
    setState(() {
      _reminders.removeAt(index);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('reminders', _reminders);
  }

  Future<void> _editReminder(int index) async {
    _reminderController.text = _reminders[index];
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("تعديل التذكير"),
          content: TextField(
            controller: _reminderController,
            decoration: const InputDecoration(labelText: "التذكير"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_reminderController.text.isNotEmpty) {
                  setState(() {
                    _reminders[index] = _reminderController.text;
                  });
                  _deleteReminder(index);
                  _addReminder();
                  Navigator.of(context).pop();
                }
              },
              child: const Text("تعديل"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("إلغاء"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التذكيرات اليومية"),
        backgroundColor: const Color(0xFF4C7EFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "إعداد تذكيراتك اليومية",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _reminderController,
              decoration: const InputDecoration(
                labelText: "التذكير",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addReminder,
              child: const Text("حفظ التذكير"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(_reminders[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editReminder(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteReminder(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}