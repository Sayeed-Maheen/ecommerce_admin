import 'package:ecommerce_admin/features/categories/domain/entities/category.dart';
import 'package:ecommerce_admin/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key, required this.onSubmit, required this.categories, this.product});

  final Future<void> Function(
    String name,
    String description,
    String categoryId,
    double price,
    bool isActive,
  )
  onSubmit;

  final List<Category> categories;
  final Product? product;

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String? _categoryId;
  bool _isActive = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _categoryId = widget.product!.categoryId;
      _isActive = widget.product!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_categoryId == null) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.onSubmit(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
        _categoryId!,
        double.parse(_priceController.text.trim()),
        _isActive,
      );
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
              labelText: 'Product Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Product name is required';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: _categoryId,
            decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
            items: widget.categories.map((category) {
              return DropdownMenuItem<String>(value: category.id, child: Text(category.name));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _categoryId = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Category is required';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Price is required';
              }

              final price = double.tryParse(value.trim());

              if (price == null || price < 0) {
                return 'Enter a valid price';
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
                  : const Text('Save Product'),
            ),
          ),
        ],
      ),
    );
  }
}
