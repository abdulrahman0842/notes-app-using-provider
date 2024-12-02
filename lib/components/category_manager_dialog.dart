import 'package:flutter/material.dart';
import 'package:task_management_with_provider/components/custom_text_field.dart';
import 'package:task_management_with_provider/models/category.dart';

class CategoryManagerDialog extends StatefulWidget {
  CategoryManagerDialog({super.key, required this.isEditing, this.category});

  final bool isEditing;
  Category? category;
  @override
  State<CategoryManagerDialog> createState() => _CategoryManagerDialogState();
}

class _CategoryManagerDialogState extends State<CategoryManagerDialog> {
  TextEditingController _categoryNameController = TextEditingController();
  Color _selectedColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.isEditing ? 'Edit Category' : "Add New Category",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          CustomTextField(
              hintText: 'Category Name',
              controller: widget.isEditing
                  ? TextEditingController(text: widget.category!.name)
                  : _categoryNameController),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                _showColorPicker(context, _selectedColor);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Pick Color'))
        ],
      ),
    );
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
