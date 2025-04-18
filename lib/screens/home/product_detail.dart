import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/models/models.dart';
import 'package:realm/realm.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  final List<ProductSize> productSizes;
  final List<Topping> toppings;

  ProductDetail({
    required this.product,
    required this.productSizes,
    required this.toppings
  });

  @override
  State<StatefulWidget> createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> {
  ObjectId? selectedSizeId;
  List<ObjectId> selectedToppings = [];

  int quantity = 1;
  double totalPrice = 0;

  void updateTotalPrice() {
    if(selectedSizeId==null)
    {
      return;
    }

    final basePrice = widget.product.price;

    final sizePrice = widget.productSizes.firstWhere(
          (size) => size.id == selectedSizeId,
    ).additionalPrice;

    final double toppingsPrice = widget.toppings
        .where((topping) => selectedToppings.contains(topping.id))
        .fold(0, (sum, topping) => sum + topping.price);

    setState(() {
      totalPrice = (basePrice + sizePrice + toppingsPrice) * quantity;
    });
  }

  @override
  void initState() {
    super.initState();
    updateTotalPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Chi tiết sản phẩm"),
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 120),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh sản phẩm
                    widget.product.img.isEmpty
                        ? Image.asset(
                      "assets/images/img_unavailable",
                      width: double.infinity,
                      height: 360,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/images/Cà phê sữa.png',
                      width: double.infinity,
                      height: 360,
                      fit: BoxFit.cover,
                    ),
                    // Tên sản phẩm, nút add vào wishlist
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.name,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.left,
                        ),

                        IconButton(
                          onPressed: (){
                            // xử lý thêm vào wishlist
                          },
                          icon: Icon(Icons.favorite),
                          alignment: Alignment.centerRight,
                        )
                      ],
                    ),

                    SizedBox(height: 12),

                    // Size
                    Text("Chọn size:", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.productSizes.length,
                        itemBuilder: (context, index) {
                          final productSize = widget.productSizes[index];
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<ObjectId>(
                                value: productSize.id,
                                groupValue: selectedSizeId,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSizeId = value;
                                  });
                                  updateTotalPrice();
                                },
                              ),
                              Text("${productSize.size?.name} (${productSize.additionalPrice + widget.product.price}đ)"),
                              SizedBox(width: 12),
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 16),

                    // Topping
                    Text("Chọn topping:", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.toppings.length,
                        itemBuilder: (context, index) {
                          final topping = widget.toppings[index];
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: Checkbox(
                                  value: selectedToppings.contains(topping.id),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedToppings.add(topping.id);
                                      } else {
                                        selectedToppings.remove(topping.id);
                                      }
                                    });
                                    updateTotalPrice();
                                  },
                                  activeColor: Colors.brown,
                                  checkColor: Colors.white,
                                  side: BorderSide(color: Colors.brown),
                                ),
                              ),
                              Text(
                                "${topping.name} (+${topping.price}đ)",
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(width: 12),
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 24),

                    // Ghi chú
                    Text("Ghi chú:", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Nhập yêu cầu thêm, ví dụ: ít đá, ít đường...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${quantity} sản phẩm", style: TextStyle(color: Colors.grey[700])),
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
                            Text("$quantity", style: TextStyle(fontSize: 18)),
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
                        Text("${totalPrice}đ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ElevatedButton(
                          onPressed: () {
                            // xử lý thêm vào giỏ hàng
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: Text("Thêm vào giỏ hàng", style: TextStyle(color: Colors.white)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
