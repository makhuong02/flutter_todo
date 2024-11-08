import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/todo.dart';

class TodoFormPage extends StatefulWidget {
  @override
  _TodoFormPageState createState() => _TodoFormPageState();
}

class _TodoFormPageState extends State<TodoFormPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _submitTodo() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isNotEmpty && _dueDate != null) {
      final newTodo = Todo(
        title: title,
        description: description,
        dueDate: _dueDate!,
      );

      // Schedule notification 10 minutes before the due time
      _scheduleNotification(newTodo);

      Navigator.pop(context, newTodo);
    }
  }

  Future<void> _scheduleNotification(Todo todo) async {
    final notificationTime = todo.dueDate.subtract(Duration(minutes: 10));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      todo.dueDate.hashCode,
      'Reminder for ${todo.title}',
      'You have a TODO due soon: ${todo.title}',
      tz.TZDateTime.from(notificationTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_reminder_channel',
          'TODO Reminders',
          channelDescription: 'Channel for TODO reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBadge: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode:
          AndroidScheduleMode.exact, // Daily reminder at the same time
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New TODO')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextButton(
              onPressed: () async {
                final now = DateTime.now();
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    if (pickedTime.hour >= now.hour &&
                        pickedTime.minute > now.minute) {
                      _dueDate = DateTime(pickedDate!.year, pickedDate.month,
                          pickedDate.day, pickedTime.hour, pickedTime.minute);
                      setState(() {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Please select a time in the future")),
                      );
                      return;
                    }
                  }
                }
              },
              child: Text(_dueDate == null
                  ? 'Select Due Date'
                  : 'Due Date: ${_dueDate!.toLocal()}'.split(' ')[0]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTodo,
              child: const Text('Add TODO'),
            ),
          ],
        ),
      ),
    );
  }
}
