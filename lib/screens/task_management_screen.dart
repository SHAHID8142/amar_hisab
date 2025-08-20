import 'package:amar_hisab/models/task.dart';
import 'package:amar_hisab/providers/task_provider.dart';
import 'package:amar_hisab/services/google_drive_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  TaskManagementScreenState createState() => TaskManagementScreenState();
}

class TaskManagementScreenState extends State<TaskManagementScreen> {
  final GoogleDriveService _googleDriveService = GoogleDriveService();

  void _addTask() {
    _showTaskDialog();
  }

  void _editTask(Task task) {
    _showTaskDialog(task: task);
  }

  void _deleteTask(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to delete this task?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).deleteTask(id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _toggleTaskStatus(String id) {
    Provider.of<TaskProvider>(context, listen: false).toggleTaskStatus(id);
  }

  void _showTaskDialog({Task? task}) {
    final titleController = TextEditingController(text: task?.title);
    final descriptionController = TextEditingController(
      text: task?.description,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;

                if (title.isNotEmpty) {
                  if (task == null) {
                    Provider.of<TaskProvider>(context, listen: false).addTask(
                      Task(
                        id: DateTime.now().toString(),
                        title: title,
                        description: description,
                      ),
                    );
                  } else {
                    Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    ).updateTask(
                      Task(
                        id: task.id,
                        title: title,
                        description: description,
                        isCompleted: task.isCompleted,
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.backup),
            onPressed: () => _googleDriveService.backupData(context),
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () => _googleDriveService.restoreData(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  _toggleTaskStatus(task.id);
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: Text(task.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => _editTask(task),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(task.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
