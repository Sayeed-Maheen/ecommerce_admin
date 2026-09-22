import 'package:ecommerce_admin/features/categories/domain/entities/category.dart';
import 'package:ecommerce_admin/features/categories/presentation/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({super.key, required this.onSubmit, this.category});

  final Future<void> Function(String name, bool isActive) onSubmit;
  final Category? category;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isActive = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _isActive = widget.category!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.onSubmit(_nameController.text.trim(), _isActive);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Category Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Category name is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Active'),
            value: _isActive,
            onChanged: (value) {
              setState(() => _isActive = value);
            },
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Category'),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryFormPage extends GetView<CategoryController> {
  const CategoryFormPage({super.key, this.category});

  final Category? category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category == null ? 'Add Category' : 'Edit Category')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: CategoryForm(
          category: category,
          onSubmit: (name, isActive) async {
            final categoryToSave = Category(id: category?.id ?? '', name: name, isActive: isActive);

            final success = category == null
                ? await controller.createCategory(categoryToSave)
                : await controller.updateCategory(categoryToSave);

            if (success && context.mounted) {
              context.pop();
            } else if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(controller.errorMessage.value)));
            }
          },
        ),
      ),
    );
  }
}
