import 'package:flutter/widgets.dart';
import 'package:flutter_coffee_shop_app/screens/home/home_screen.dart';
import 'package:flutter_coffee_shop_app/screens/home/widgets/product_card.dart';

class CartScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return CartScreenState();
  }
}

class CartScreenState extends State<CartScreen>
{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // GridView.builder(
        //   itemCount: filteredProducts.length,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 2,
        //       mainAxisSpacing: 5,
        //       crossAxisSpacing: 10,
        //       childAspectRatio: 0.75
        //   ),
        //   itemBuilder: (context, index) {
        //     return ProductCard(
        //       // tạm thời cho giống nhau hết
        //         imageUrl: 'assets/images/Cà phê sữa.png',
        //         name: filteredProducts
        //             .elementAt(index)
        //             .name,
        //         price: filteredProducts.elementAt(index).price,
        //         onAdd: () {}
        //     );
        //   },
        // )
        Text("Cart screen")
      ]
    );
  }
}