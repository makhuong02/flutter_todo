import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class TodoListTab extends StatelessWidget {
  final List<Todo> todos;
  final Function(Todo) toggleComplete;

  const TodoListTab(
      {super.key, required this.todos, required this.toggleComplete});

  String _formatDueDate(DateTime dueDate) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return dateFormat.format(dueDate);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          title: Text(todo.title),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Description: ${todo.description}'),
            Text('Due: ${_formatDueDate(todo.dueDate)}'),
          ]),
          trailing: Checkbox(
            value: todo.isCompleted,
            onChanged: (value) {
              toggleComplete(todo);
            },
          ),
        );
      },
    );
  }
}
