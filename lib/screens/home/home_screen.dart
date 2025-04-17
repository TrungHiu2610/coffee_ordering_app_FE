import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_coffee_shop_app/screens/home/widgets/banner.dart';
import 'package:flutter_coffee_shop_app/screens/home/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  int selectedBottomBarIndex = 0;

  final List<String> categories = ['Tất cả', 'Cà phê', 'Trà sữa', 'Sinh tố'];

  // Giả lập danh sách món
  final List<Drink> allDrinks = [
    Drink(name: 'Cà phê sữa', category: 'Cà phê'),
    Drink(name: 'Trà sữa truyền thống', category: 'Trà sữa'),
    Drink(name: 'Sinh tố xoài', category: 'Sinh tố'),
  ];

  // Giả lập danh sách banner
  final List<String> imgList = [
    'assets/images/banner_1.png',
    'assets/images/banner_2.png',
    'assets/images/banner_3.png',
  ];

  @override
  Widget build(BuildContext context) {
    String selectedCategory = categories[selectedCategoryIndex];

    List<Drink> filteredDrinks = selectedCategory == 'Tất cả'
        ? allDrinks
        : allDrinks.where((d) => d.category == selectedCategory).toList();

    return Column(
      children: [
        SizedBox(height: 12),

        // Banner quảng cáo
        // BannerCarousel(imgList:imgList),

        SizedBox(height: 24),

        Container(
          child: Text(
            textAlign: TextAlign.left,
            "Categories",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.brown,
            ),
          ),
          alignment: Alignment.topLeft,
        ),


        SizedBox(height: 24),

        // Chip lọc danh mục
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(categories[index]),
                  selected: selectedCategoryIndex == index,
                  onSelected: (_) {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                ),
              );
            },
          ),
        ),
        // Danh sách đồ uống
        Expanded(
          child: GridView.builder(
            itemCount: filteredDrinks.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75
            ),
            itemBuilder: (context, index) {
              return ProductCard(
                  imageUrl: 'assets/images/' + filteredDrinks
                      .elementAt(index)
                      .name + '.png',
                  name: filteredDrinks
                      .elementAt(index)
                      .name,
                  price: 45000,
                  onAdd: () {}
              );
            },
          ),
        ),
      ],
    );
  }
}
// Model đơn giản
class Drink {
  final String name;
  final String category;

  Drink({required this.name, required this.category});
}
