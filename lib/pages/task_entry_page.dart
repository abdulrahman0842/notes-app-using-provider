import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management_with_provider/components/custom_text_field.dart';
import 'package:task_management_with_provider/models/category.dart';
import 'package:task_management_with_provider/models/task.dart';
import 'package:task_management_with_provider/providers/category_provider.dart';
import 'package:task_management_with_provider/providers/task_provider.dart';

class TaskEntryWidget extends StatefulWidget {
  TaskEntryWidget(
      {super.key,
      // this.category,
      this.task,
      // this.priority,
      required this.isEditing});

  final bool isEditing;
  Task? task;
  // String? priority;
  // Category? category;
  @override
  State<TaskEntryWidget> createState() => _TaskEntryWidgetState();
}

class _TaskEntryWidgetState extends State<TaskEntryWidget> {
  List<Category> categories = [];
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  String priority = 'Low';
  String? dueDate;
  Category? category;

  Future<void> _selectDueData(context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (selectedDate == null) {
      return;
    }
    final TimeOfDay? selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedTime == null) {
      return;
    }
    DateTime selectedDueDate = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
    String formatedDateTime =
        DateFormat('dd-mm-yyyy hh:mm a').format(selectedDueDate);
    dueDate = formatedDateTime;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    categories = context.read<CategoryProvider>().categories;
    if (widget.isEditing) {
      titleController = TextEditingController(text: widget.task!.title);

      descriptionController =
          TextEditingController(text: widget.task!.description);

      category = context
          .read<CategoryProvider>()
          .getCategoryById(widget.task!.categoryId);
      priority = widget.task!.priority;
      dueDate = widget.task!.dueAt;
    } else {
      titleController = TextEditingController();
      descriptionController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(widget.isEditing ? 'Edit Note' : 'Add a Note')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                        hintText: 'Title', controller: titleController),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        hintText: 'Description',
                        controller: descriptionController),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Priority:', style: TextStyle(fontSize: 16)),
                    Wrap(
                      spacing: 20,
                      children: [
                        _buildRadioButton('Low', Colors.green.shade600),
                        _buildRadioButton('Medium', Colors.orange.shade600),
                        _buildRadioButton('High', Colors.red.shade600),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButton<Category>(
                        value: category,
                        hint: const Text('Select a Category'),
                        isExpanded: true,
                        items: categories.map((Category category) {
                          return DropdownMenuItem<Category>(
                              value: category, child: Text(category.name));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            category = value;
                          });
                        }),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              _selectDueData(context);
                            },
                            child: Text(
                              widget.isEditing
                                  ? 'Change due date'
                                  : 'Pick due date',
                            )),
                        Text(
                          dueDate ?? '',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCallActionButton(
                            'Cancel',
                            Theme.of(context).colorScheme.secondary,
                            Colors.black,
                            () => Navigator.pop(context)),
                        const SizedBox(
                          width: 10,
                        ),
                        _buildCallActionButton(
                            widget.isEditing ? "Apply Changes" : "Add Note",
                            Theme.of(context).colorScheme.primary,
                            Colors.white, () {
                          if (category != null && dueDate != null) {
                            context.read<TaskProvider>().createTask(
                                titleController.text,
                                descriptionController.text,
                                priority,
                                category!.categoryId,
                                dueDate);
                            titleController.clear();
                            descriptionController.clear();
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Fill all the fields')));
                          }
                        })
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Row _buildRadioButton(String value, Color color) {
    return Row(
      children: [
        Radio(
            activeColor: color,
            value: value,
            groupValue: priority,
            onChanged: (newValue) {
              setState(() {
                priority = newValue!;
              });
              log(priority);
            }),
        Text(value),
      ],
    );
  }

  Widget _buildCallActionButton(String label, Color backgroundColor,
      Color textColor, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            onTap();
          },
          child: Text(
            label,
          )),
    );
  }
}
