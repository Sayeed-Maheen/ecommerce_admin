import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controllers/product_controller.dart';

class ProductsPage extends GetView<ProductController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/products/add');
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add Product',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.products.isEmpty) {
          return const Center(child: Text('No products found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];

            return Card(
              child: ListTile(
                leading: product.imageUrl != null
                    ? Image.network(product.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.inventory_2),
                title: Text(product.name),
                subtitle: Text(
                  '${product.price.toStringAsFixed(2)} • '
                  '${product.isActive ? 'Active' : 'Inactive'}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        context.push('/products/edit/${product.id}', extra: product);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Product'),
                              content: Text('Are you sure you want to delete "${product.name}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmed != true) {
                          return;
                        }

                        final success = await controller.deleteProduct(product.id);

                        if (!success && context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(controller.errorMessage.value)));
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
