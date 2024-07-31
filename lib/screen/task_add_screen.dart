import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';

class TaskAddScreen extends StatefulWidget {
  @override
  _TaskAddScreenState createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Tarefa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Concluída:'),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCompleted = !_isCompleted;
                    });
                  },
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: _isCompleted ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final description = _descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  Provider.of<TaskProvider>(context, listen: false).addTask(
                    title,
                    description,
                    _isCompleted,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha todos os campos')),
                  );
                }
              },
              child: Text('Adicionar Tarefa'),
            ),
          ],
        ),
      ),
    );
  }
}