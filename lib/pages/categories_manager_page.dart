import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:task_management_with_provider/components/custom_text_field.dart';
import 'package:task_management_with_provider/models/category.dart';
import 'package:task_management_with_provider/providers/category_provider.dart';

class CategoriesManagerPage extends StatefulWidget {
  const CategoriesManagerPage({super.key});

  @override
  State<CategoriesManagerPage> createState() => _CategoriesManagerPageState();
}

class _CategoriesManagerPageState extends State<CategoriesManagerPage> {
  final TextEditingController _categoryNameController = TextEditingController();

  Color _selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
              onPressed: () {
                _buildNewCategoryDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add a Category'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              )),
          Expanded(child: Consumer<CategoryProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                itemCount: provider.categories.length,
                itemBuilder: (context, index) {
                  final Category category = provider.categories[index];
                  return ListTile(
                    tileColor: category.color.withOpacity(0.2),
                    title: Text(category.name),
                    subtitle: Text(category.categoryId),
                    trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _selectedColor = category.color;
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Edit Category",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        CustomTextField(
                                            hintText: 'Category Name',
                                            controller: TextEditingController(
                                                text: category.name)),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  _showColorPicker(
                                                      context, category.color);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child:
                                                    const Text('Pick Color')),
                                            Container(
                                              height: 50,
                                              width: 75,
                                              color: _selectedColor,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel')),
                                      ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<CategoryProvider>()
                                                .addCategory(
                                                    _categoryNameController
                                                        .text,
                                                    _selectedColor);
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Save Changes'))
                                    ],
                                  );
                                });
                          }
                          if (value == 'delete') {
                            provider.deleteCategory(category.categoryId);
                          }
                        },
                        itemBuilder: (context) => [
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
                                ),
                              ),
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
                                ),
                              )
                            ]),
                  );
                },
              );
            },
          ))
        ],
      ),
    );
  }

  Future<dynamic> _buildNewCategoryDialog(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Add New Category",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                CustomTextField(
                    hintText: 'Category Name',
                    controller: _categoryNameController),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      _showColorPicker(context, _selectedColor);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Pick Color'))
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    context.read<CategoryProvider>().addCategory(
                        _categoryNameController.text, _selectedColor);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'))
            ],
          );
        });
  }

  void _showColorPicker(context, Color color) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Pick a Color"),
            content: SingleChildScrollView(
              child: BlockPicker(
                  pickerColor: color,
                  onColorChanged: (color) {
                    setState(() {
                      _selectedColor = color;
                    });
                    Navigator.pop(context);
                  }),
            ),
          );
        });
  }
}
