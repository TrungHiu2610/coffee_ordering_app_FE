import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_coffee_shop_app/models/models.dart' as model;
import 'package:flutter_coffee_shop_app/screens/home/widgets/banner.dart';
import 'package:flutter_coffee_shop_app/screens/home/widgets/product_card.dart';
import 'package:flutter_coffee_shop_app/services/realm.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  int selectedBottomBarIndex = 0;

  late List<model.Category> categories = [];
  late List<model.Product> products = [];

  //danh sách banner
  final List<String> imgList = [
    'assets/images/banner_1.png',
    'assets/images/banner_2.png',
    'assets/images/banner_3.png',
  ];

  late RealmService realmService;

  @override
  void initState() {
    super.initState();

    realmService = RealmService();
    loadDataFromRealm();
  }

  void loadDataFromRealm()
  {
    final allProducts = realmService.realm.all<model.Product>();
    final allCategories = realmService.realm.all<model.Category>();

    setState(() {
      products = allProducts.toList();
      categories = allCategories.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String selectedCategory = (selectedCategoryIndex == 0 || categories.isEmpty)
        ? 'Tất cả'
        : categories[selectedCategoryIndex-1].name;

    List<model.Product> filteredProducts = selectedCategory == 'Tất cả'
        ? products
        : products.where((d) => d.category?.name == selectedCategory).toList();

    return Column(
      children: [
        SizedBox(height: 12),

        // Banner quảng cáo
        BannerCarousel(imgList:imgList),

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
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              final label = index == 0 ? 'Tất cả' : categories[index - 1].name;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(label),
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
            itemCount: filteredProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75
            ),
            itemBuilder: (context, index) {
              return ProductCard(
                // tạm thời cho giống nhau hết
                  imageUrl: 'assets/images/Cà phê sữa.png',
                  name: filteredProducts
                      .elementAt(index)
                      .name,
                  price: filteredProducts.elementAt(index).price,
                  onAdd: () {}
              );
            },
          ),
        ),
      ],
    );
  }
}
