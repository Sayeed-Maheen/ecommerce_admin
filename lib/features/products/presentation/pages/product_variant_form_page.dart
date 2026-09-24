import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/product_variant.dart';
import '../controllers/product_variant_controller.dart';
import '../widgets/product_variant_form.dart';
import 'product_variant_route_args.dart';

class ProductVariantFormPage extends GetView<ProductVariantController> {
  const ProductVariantFormPage({super.key, required this.args});

  final ProductVariantRouteArgs args;

  ProductVariant? get variant => args.variant;

  String get productId => args.product.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(variant == null ? 'Add Variant' : 'Edit Variant')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ProductVariantForm(
          initialName: variant?.name,
          initialPrice: variant?.price,
          initialStock: variant?.stock,
          initialIsActive: variant?.isActive ?? true,
          onSubmit: (name, price, stock, isActive) async {
            final variantToSave = ProductVariant(
              id: variant?.id ?? '',
              productId: productId,
              name: name,
              price: price,
              stock: stock,
              isActive: isActive,
            );

            final success = variant == null
                ? await controller.createVariant(variantToSave)
                : await controller.updateVariant(variantToSave);

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
