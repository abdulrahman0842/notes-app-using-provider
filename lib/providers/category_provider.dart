import 'package:flutter/material.dart';
import 'package:task_management_with_provider/models/category.dart';
import 'package:uuid/uuid.dart';

class CategoryProvider with ChangeNotifier {
  static final List<Category> _categories = [
    Category(categoryId: "Work", name: "Work", color: Colors.red),
    Category(categoryId: "Fitness", name: "Fitness", color: Colors.green),
    Category(categoryId: "Home", name: "Home", color: Colors.blue)
  ];
  List<Category> get categories => _categories;

  // add category
  void addCategory(String name, Color color) {
    String categoryId = const Uuid().v4();
    _categories.add(Category(categoryId: categoryId, name: name, color: color));
    notifyListeners();
  }

  // update category
  void updateCategory(Category updatedCategory) {
    int index = _categories.indexWhere(
        (category) => category.categoryId == updatedCategory.categoryId);
    _categories[index] = updatedCategory;
    notifyListeners();
  }

  // delete category
  void deleteCategory(String categoryId) {
    _categories.removeWhere((category) => category.categoryId == categoryId);
    notifyListeners();
  }

  // get category by id
  Category getCategoryById(String categoryId) {
    return _categories
        .firstWhere((category) => category.categoryId == categoryId);
  }
}
