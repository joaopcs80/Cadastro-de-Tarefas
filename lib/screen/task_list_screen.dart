import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import 'task_add_screen.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskAddScreen()),
              );
            },
          ),
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return IconButton(
                icon: Icon(taskProvider.isEditing ? Icons.cancel : Icons.edit),
                onPressed: () {
                  if (taskProvider.isEditing) {
                    taskProvider.toggleEditingMode();
                  } else {
                    // Switch to edit mode
                    taskProvider.toggleEditingMode();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Column(
            children: [
              if (taskProvider.isEditing)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Verde
                        ),
                        onPressed: () {
                          taskProvider.updateSelectedTasksStatus(true);
                        },
                        child: Text('Concluída'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Vermelho
                        ),
                        onPressed: () {
                          taskProvider.updateSelectedTasksStatus(false);
                        },
                        child: Text('Não Concluída'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          taskProvider.selectAllTasks();
                        },
                        child: Text('Slc. Todos'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: taskProvider.fetchTasks,
                  child: taskProvider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: taskProvider.tasks.length,
                          itemBuilder: (context, index) {
                            final task = taskProvider.tasks[index];
                            final isSelected = taskProvider.selectedTasks.contains(task['objectId']);
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 10,
                                backgroundColor: task['completed'] ? Colors.green : Colors.red,
                              ),
                              title: Text(task['title'] ?? 'Sem título'),
                              subtitle: Text(task['description'] ?? 'Sem descrição'),
                              trailing: taskProvider.isEditing
                                  ? Checkbox(
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        taskProvider.toggleTaskSelection(task['objectId']);
                                      },
                                    )
                                  : null,
                              onTap: () {
                                if (taskProvider.isEditing) {
                                  taskProvider.toggleTaskSelection(task['objectId']);
                                }
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}