import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_with_provider/models/category.dart';
import 'package:task_management_with_provider/providers/category_provider.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CategoryProvider>(builder: (context, provider, child) {
        return ListView.builder(
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              Category category = provider.categories[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: ListTile(
                  title: Text(category.name),
                  tileColor: category.color,
                ),
              );
            });
      }),
    );
  }
}
