import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_management_with_provider/models/task.dart';
import 'package:task_management_with_provider/pages/task_entry_page.dart';
import 'package:task_management_with_provider/providers/task_provider.dart';

class CustomPopUpMenuButton extends StatelessWidget {
  const CustomPopUpMenuButton(
      {super.key, required this.task, required this.provider});

  final Task task;
  final TaskProvider provider;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        onSelected: (String value) {
          if (value == 'edit') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskEntryWidget(
                          isEditing: true,
                          task: task,
                        )));
          } else if (value == 'delete') {
            provider.deleteTask(task.id);
          } else {
            provider.toggleStatus(task.id);
            log("${task.title} : ${task.status.toString()}");
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<String>>[
              const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Edit')
                    ],
                  )),
              const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Delete')
                    ],
                  )),
              const PopupMenuItem(
                  value: 'done',
                  child: Row(
                    children: [
                      Icon(Icons.done),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Completed')
                    ],
                  ))
            ]);
  }
}
