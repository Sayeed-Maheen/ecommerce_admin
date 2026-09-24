import 'package:flutter/material.dart';

class ProductVariantForm extends StatefulWidget {
  const ProductVariantForm({
    super.key,
    this.initialName,
    this.initialPrice,
    this.initialStock,
    this.initialIsActive = true,
    required this.onSubmit,
  });

  final String? initialName;
  final double? initialPrice;
  final int? initialStock;
  final bool initialIsActive;

  final Future<void> Function(String name, double price, int stock, bool isActive) onSubmit;

  @override
  State<ProductVariantForm> createState() => _ProductVariantFormState();
}

class _ProductVariantFormState extends State<ProductVariantForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;

  late bool _isActive;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialName ?? '');

    _priceController = TextEditingController(text: widget.initialPrice?.toString() ?? '');

    _stockController = TextEditingController(text: widget.initialStock?.toString() ?? '');

    _isActive = widget.initialIsActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await widget.onSubmit(
      _nameController.text.trim(),
      double.parse(_priceController.text.trim()),
      int.parse(_stockController.text.trim()),
      _isActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Variant Name',
              hintText: 'e.g. Small, Medium, Large',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Variant name is required.';
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
              final price = double.tryParse(value?.trim() ?? '');

              if (price == null) {
                return 'Enter a valid price.';
              }

              if (price < 0) {
                return 'Price cannot be negative.';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _stockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder()),
            validator: (value) {
              final stock = int.tryParse(value?.trim() ?? '');

              if (stock == null) {
                return 'Enter a valid stock quantity.';
              }

              if (stock < 0) {
                return 'Stock cannot be negative.';
              }

              return null;
            },
          ),

          const SizedBox(height: 8),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Active'),
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
              });
            },
          ),

          const SizedBox(height: 20),

          FilledButton(onPressed: _submit, child: const Text('Save Variant')),
        ],
      ),
    );
  }
}
