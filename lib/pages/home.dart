import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_with_provider/components/custom_pop_up_menu_button.dart';
import 'package:task_management_with_provider/components/my_drawer.dart';
import 'package:task_management_with_provider/models/category.dart';
import 'package:task_management_with_provider/models/task.dart';
import 'package:task_management_with_provider/pages/task_entry_page.dart';
import 'package:task_management_with_provider/providers/category_provider.dart';
import 'package:task_management_with_provider/providers/task_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Keep Notes'),
      ),
      drawer: const MyDrawer(),
      body: Consumer<TaskProvider>(builder: (context, provider, child) {
        return provider.tasks.isEmpty
            ? const Center(
                child: Text('No task'),
              )
            : ListView.builder(
                itemCount: provider.tasks.length,
                itemBuilder: (context, index) {
                  Task task = provider.tasks[index];
                  Category category = context
                      .read<CategoryProvider>()
                      .getCategoryById(task.categoryId);
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: category.color, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Text(
                                task.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                task.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: CustomPopUpMenuButton(
                                task: task,
                                provider: provider,
                              )),
                          const Divider(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text(
                                    "Priority: ${task.priority}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor:
                                      category.color.withOpacity(0.2),
                                ),
                                Text(
                                  task.dueAt,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskEntryWidget(
                        isEditing: false,
                      )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
