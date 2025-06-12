import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/screens/review/product_reviews_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';

import '../../providers/cart_provider.dart';
import '../../services/api_client.dart';
import '../../services/dio_client.dart';
import '../../services/product_service.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  final int? tableNumber;

  ProductDetail({required this.product, this.tableNumber});

  @override
  State<StatefulWidget> createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> {
  final TextEditingController txtGhiChu = TextEditingController();
  final ApiClient _apiClient = ApiClient(DioClient().dio);
  final ProductService _productService = ProductService();

  int? selectedSizeId;
  List<int> selectedToppingIds = [];
  List<Topping> toppings = [];
  bool isLoading = true;
  Product? fullProductData;

  int quantity = 1;
  double totalPrice = 0;

  void updateTotalPrice() {
    if (selectedSizeId == null) {
      return;
    }

    final basePrice = fullProductData?.price ?? widget.product.price;

    // Find selected size price
    final productSize = fullProductData?.productSizes?.firstWhere(
      (size) => size.sizeId == selectedSizeId,
      orElse:
          () => ProductSize(
            id: 0,
            productId: widget.product.id,
            sizeId: 0,
            additionalPrice: 0,
          ),
    );

    final sizePrice = productSize?.additionalPrice ?? 0;

    // Calculate toppings price
    double toppingsPrice = 0;
    for (final toppingId in selectedToppingIds) {
      final topping = toppings.firstWhere(
        (t) => t.id == toppingId,
        orElse: () => Topping(id: 0, name: '', price: 0),
      );
      toppingsPrice += topping.price;
    }

    setState(() {
      totalPrice = (basePrice + sizePrice + toppingsPrice) * quantity;
    });
  }

  Future<void> loadProductDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch the full product details including sizes and toppings
      final product = await _productService.getProduct(widget.product.id);

      if (product != null) {
        setState(() {
          fullProductData = product;

          // Set default size if available
          if (fullProductData!.productSizes != null &&
              fullProductData!.productSizes!.isNotEmpty) {
            selectedSizeId = fullProductData!.productSizes!.first.sizeId;
          }

          // Load toppings from product
          if (fullProductData!.productToppings != null) {
            toppings =
                fullProductData!.productToppings!
                    .where((pt) => pt.topping != null)
                    .map((pt) => pt.topping!)
                    .toList();
          }

          updateTotalPrice();
          isLoading = false;
        });

        if (kDebugMode) {
          print('Product sizes: ${fullProductData?.productSizes?.length ?? 0}');
          if (fullProductData?.productSizes != null) {
            for (var size in fullProductData!.productSizes!) {
              print('Size: ${size.size?.name}, Price: ${size.additionalPrice}');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading product details: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize fullProductData with widget.product as a fallback
    fullProductData = widget.product;
    // Load complete product details including sizes and toppings
    loadProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chi tiết sản phẩm",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.rate_review),
            tooltip: 'Xem đánh giá',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProductReviewsScreen(
                        productId: widget.product.id,
                        productName: widget.product.name,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 120),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hình ảnh sản phẩm
                            CachedNetworkImage(
                              imageUrl: widget.product.imageUrl,
                              width: double.infinity,
                              height: 360,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              errorWidget:
                                  (context, url, error) => Image.asset(
                                    "assets/images/img_unavailable.jpg",
                                    width: double.infinity,
                                    height: 360,
                                    fit: BoxFit.cover,
                                  ),
                            ), // Tên sản phẩm, nút add vào wishlist
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),

                                IconButton(
                                  onPressed: () {
                                    // xử lý thêm vào wishlist
                                  },
                                  icon: Icon(Icons.favorite),
                                  alignment: Alignment.centerRight,
                                ),
                              ],
                            ),

                            // Rating & Reviews section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index <
                                              (widget
                                                          .product
                                                          .reviews
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? widget.product.reviews!
                                                          .map((r) => r.rating)
                                                          .reduce(
                                                            (a, b) => a + b,
                                                          ) ~/
                                                      widget
                                                          .product
                                                          .reviews!
                                                          .length
                                                  : 0)
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 18,
                                    );
                                  }),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ProductReviewsScreen(
                                              productId: widget.product.id,
                                              productName: widget.product.name,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Xem đánh giá (${widget.product.reviews?.length ?? 0})',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12), // Size
                            Text(
                              "Chọn size:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              constraints: BoxConstraints(maxHeight: 200),
                              child:
                                  fullProductData?.productSizes == null ||
                                          fullProductData!.productSizes!.isEmpty
                                      ? Center(
                                        child: Text(
                                          "Không có kích thước cho sản phẩm này",
                                        ),
                                      )
                                      : SingleChildScrollView(
                                        child: Column(
                                          children:
                                              (fullProductData?.productSizes ?? []).map((
                                                productSize,
                                              ) {
                                                if (kDebugMode) {
                                                  print(
                                                    'Rendering size: ${productSize.size?.name}, ID: ${productSize.sizeId}, Additional Price: ${productSize.additionalPrice}',
                                                  );
                                                }
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                    bottom: 8,
                                                  ),
                                                  child: Card(
                                                    elevation:
                                                        selectedSizeId ==
                                                                productSize
                                                                    .sizeId
                                                            ? 3
                                                            : 1,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                          vertical: 4,
                                                          horizontal: 8,
                                                        ),
                                                    color:
                                                        selectedSizeId ==
                                                                productSize
                                                                    .sizeId
                                                            ? Colors
                                                                .cyan
                                                                .shade50
                                                            : null,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedSizeId =
                                                              productSize
                                                                  .sizeId;
                                                        });
                                                        updateTotalPrice();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              8.0,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            Radio<int>(
                                                              value:
                                                                  productSize
                                                                      .sizeId,
                                                              groupValue:
                                                                  selectedSizeId,
                                                              onChanged: (
                                                                value,
                                                              ) {
                                                                setState(() {
                                                                  selectedSizeId =
                                                                      value;
                                                                });
                                                                updateTotalPrice();
                                                              },
                                                              activeColor:
                                                                  Colors.cyan,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "${productSize.size?.name ?? 'Size'}",
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Giá: ${(productSize.additionalPrice + (fullProductData?.price ?? widget.product.price)).toStringAsFixed(0)}đ",
                                                                    style: TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .grey[700],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                            ),
                            SizedBox(height: 16), // Topping
                            Text(
                              "Chọn topping:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 220,
                              child:
                                  toppings.isEmpty
                                      ? Center(
                                        child: Text(
                                          "Không có topping cho sản phẩm này",
                                        ),
                                      )
                                      : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: toppings.length,
                                        itemBuilder: (context, index) {
                                          final topping = toppings[index];
                                          final isSelected = selectedToppingIds
                                              .contains(topping.id);

                                          return Card(
                                            elevation: isSelected ? 2 : 1,
                                            margin: EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 8,
                                            ),
                                            color:
                                                isSelected
                                                    ? Colors.amber.shade50
                                                    : null,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (isSelected) {
                                                    selectedToppingIds.remove(
                                                      topping.id,
                                                    );
                                                  } else {
                                                    selectedToppingIds.add(
                                                      topping.id,
                                                    );
                                                  }
                                                });
                                                updateTotalPrice();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      value: isSelected,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (value == true) {
                                                            selectedToppingIds
                                                                .add(
                                                                  topping.id,
                                                                );
                                                          } else {
                                                            selectedToppingIds
                                                                .remove(
                                                                  topping.id,
                                                                );
                                                          }
                                                        });
                                                        updateTotalPrice();
                                                      },
                                                      activeColor: Colors.brown,
                                                      checkColor: Colors.white,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            topping.name,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Text(
                                                            "+${topping.price}đ",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors
                                                                      .grey[700],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                            ),

                            SizedBox(height: 24),

                            // Ghi chú
                            Text("Ghi chú:", style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8),
                            TextField(
                              controller: txtGhiChu,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText:
                                    "Nhập yêu cầu thêm, ví dụ: ít đá, ít đường...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),

                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),

                    // Số lượng sp, tổng tiền, add to cart
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${quantity} sản phẩm",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (quantity > 1) {
                                          setState(() {
                                            quantity--;
                                          });
                                          updateTotalPrice();
                                        }
                                      },
                                      icon: Icon(Icons.remove),
                                    ),
                                    Text(
                                      "$quantity",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          quantity++;
                                        });
                                        updateTotalPrice();
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${totalPrice}đ",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (selectedSizeId == null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Vui lòng chọn size trước khi thêm vào giỏ hàng",
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    final cartProvider =
                                        Provider.of<CartProvider>(
                                          context,
                                          listen: false,
                                        );

                                    // Set table number if available
                                    if (widget.tableNumber != null) {
                                      cartProvider.setTableNumber(
                                        widget.tableNumber,
                                      );
                                    }
                                    // Add to cart using new API model
                                    cartProvider.addToCart(
                                      productId:
                                          fullProductData?.id ??
                                          widget.product.id,
                                      sizeId: selectedSizeId!,
                                      quantity: quantity,
                                      notes: txtGhiChu.text,
                                      toppingIds: selectedToppingIds,
                                    );

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Đã thêm vào giỏ hàng"),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyan,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: Text(
                                    "Thêm vào giỏ hàng",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
