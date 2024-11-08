import 'package:flutter/material.dart';
import 'package:todolist/pages/todo_form.dart';
import 'package:todolist/pages/todo_list_tab.dart';

import '../models/todo.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Todo> _todos = [];

  // Adds a new TODO to the list
  void _addTodo(Todo todo) {
    setState(() {
      _todos.add(todo);
    });
  }

  // Toggles a TODO as completed
  void _toggleComplete(Todo todo) {
    setState(() {
      todo.isCompleted = !todo.isCompleted;
    });
  }

  // Filters the TODOs for each category
  List<Todo> get todosToday {
    return _todos.where((todo) {
      return todo.dueDate.day == DateTime.now().day &&
          todo.dueDate.month == DateTime.now().month &&
          todo.dueDate.year == DateTime.now().year;
    }).toList();
  }

  List<Todo> get upcomingTodos {
    return _todos.where((todo) =>
    todo.dueDate.isAfter(DateTime.now()) && !todo.isCompleted
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TODO List'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Today'),
              Tab(text: 'Upcoming'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TodoListTab(todos: _todos, toggleComplete: _toggleComplete),
            TodoListTab(todos: todosToday, toggleComplete: _toggleComplete),
            TodoListTab(todos: upcomingTodos, toggleComplete: _toggleComplete),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newTodo = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoFormPage(),
              ),
            );

            if (newTodo != null) {
              _addTodo(newTodo);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
