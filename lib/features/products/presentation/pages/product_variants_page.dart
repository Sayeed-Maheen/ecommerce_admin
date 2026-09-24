import 'package:ecommerce_admin/features/products/presentation/pages/product_variant_route_args.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/product.dart';
import '../controllers/product_variant_controller.dart';

class ProductVariantsPage extends GetView<ProductVariantController> {
  const ProductVariantsPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${product.name} Variants')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.variants.isEmpty) {
          return const Center(child: Text('No variants found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.variants.length,
          itemBuilder: (context, index) {
            final variant = controller.variants[index];

            return Card(
              child: ListTile(
                title: Text(variant.name),
                subtitle: Text('Price: ${variant.price} • Stock: ${variant.stock}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(variant.isActive ? 'Active' : 'Inactive'),
                    const SizedBox(width: 12),
                    IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        context.push(
                          '/products/${product.id}/variants/edit/${variant.id}',
                          extra: ProductVariantRouteArgs(product: product, variant: variant),
                        );
                      },
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Variant'),
                              content: Text('Are you sure you want to delete "${variant.name}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmed == true) {
                          await controller.deleteVariant(variant.id);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/products/${product.id}/variants/add', extra: product);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Variant'),
      ),
    );
  }
}
