import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap
  });

  String _formatPrice() {
    if (product.productSizes != null && product.productSizes!.isNotEmpty) {
      // Find the minimum total price (base price + additional price)
      var prices = product.productSizes!.map((ps) => product.price + ps.additionalPrice);
      var minPrice = prices.reduce((a, b) => a < b ? a : b);
      return "${minPrice.toStringAsFixed(0)}đ";
    }
    return "${product.price.toStringAsFixed(0)}đ";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh món
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.imageUrl.startsWith('assets/') 
                  ? Image.asset(
                      product.imageUrl,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/img_unavailable.jpg',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
              ),

              SizedBox(height: 8),

              // Tên món
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 4),

              // Kích thước có sẵn
              if (product.productSizes != null && product.productSizes!.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.straighten, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        product.productSizes!.map((ps) => ps.size?.name ?? '').join(', '),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 8), // Consistent spacing

              // Giá và nút +
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatPrice(),
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: onTap,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.add_circle, color: Colors.orange),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
