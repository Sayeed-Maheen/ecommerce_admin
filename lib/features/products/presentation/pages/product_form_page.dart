import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../categories/presentation/controllers/category_controller.dart';
import '../../domain/entities/product.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_form.dart';

class ProductFormPage extends GetView<ProductController> {
  const ProductFormPage({super.key, this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();

    return Scaffold(
      appBar: AppBar(title: Text(product == null ? 'Add Product' : 'Edit Product')),
      body: Obx(() {
        if (categoryController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (categoryController.errorMessage.value.isNotEmpty) {
          return Center(child: Text(categoryController.errorMessage.value));
        }

        if (categoryController.categories.isEmpty) {
          return const Center(child: Text('Please create a category first.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ProductForm(
            product: product,
            categories: categoryController.categories,
            onSubmit: (name, description, categoryId, price, isActive) async {
              final productToSave = Product(
                id: product?.id ?? '',
                name: name,
                description: description,
                categoryId: categoryId,
                price: price,
                isActive: isActive,
              );

              final success = product == null
                  ? await controller.createProduct(productToSave)
                  : await controller.updateProduct(productToSave);

              if (success && context.mounted) {
                context.pop();
              } else if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(controller.errorMessage.value)));
              }
            },
          ),
        );
      }),
    );
  }
}
