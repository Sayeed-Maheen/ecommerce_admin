import '../../domain/entities/product.dart';
import '../../domain/entities/product_variant.dart';

class ProductVariantRouteArgs {
  final Product product;
  final ProductVariant? variant;

  const ProductVariantRouteArgs({required this.product, this.variant});
}
