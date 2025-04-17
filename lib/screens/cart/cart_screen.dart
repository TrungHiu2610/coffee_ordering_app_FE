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
        ListView.builder(
            itemCount: HomeScreenState().allDrinks.length,
          itemBuilder: (context,index) => ProductCard(
              imageUrl: 'assets/images/' + HomeScreenState().allDrinks.elementAt(index).name + '.png',
              name: HomeScreenState().allDrinks.elementAt(index).name,
              price: 45000,
              onAdd: () {}
        )
        )
      ]
    );
  }

}