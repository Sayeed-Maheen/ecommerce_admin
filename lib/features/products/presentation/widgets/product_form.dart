import 'dart:typed_data';

import 'package:ecommerce_admin/core/services/image_service.dart';
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
    Uint8List? imageBytes,
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

  Uint8List? _imageBytes;
  bool _isPickingImage = false;

  final ImageService _imageService = ImageService();

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
        _imageBytes,
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _pickImage() async {
    setState(() {
      _isPickingImage = true;
    });

    try {
      final bytes = await _imageService.pickAndCompressImage();

      if (bytes != null) {
        setState(() {
          _imageBytes = bytes;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
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
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _imageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                  )
                : widget.product?.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product!.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : const Center(child: Icon(Icons.image_outlined, size: 60)),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: _isPickingImage ? null : _pickImage,
            icon: _isPickingImage
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.photo_library_outlined),
            label: Text(_imageBytes == null ? 'Select Image' : 'Change Image'),
          ),

          const SizedBox(height: 20),

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
