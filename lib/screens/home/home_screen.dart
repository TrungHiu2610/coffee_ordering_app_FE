import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/providers/table_provider.dart';
import 'package:flutter_coffee_shop_app/screens/home/product_detail.dart';
import 'package:flutter_coffee_shop_app/screens/home/widgets/banner.dart';
import 'package:flutter_coffee_shop_app/screens/home/widgets/product_card.dart';
import 'package:flutter_coffee_shop_app/screens/widgets/appbar_home.dart';
import 'package:flutter_coffee_shop_app/screens/widgets/error_display.dart';
import 'package:flutter_coffee_shop_app/screens/widgets/loading_display.dart';
import 'package:flutter_coffee_shop_app/services/api_exception.dart';
import 'package:flutter_coffee_shop_app/services/product_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  int selectedBottomBarIndex = 0;

  late List<Category> categories = [];
  late List<Product> products = [];
  late List<Product> filteredProducts = [];
  bool isLoading = true;
  String? errorMessage;
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  //danh sách banner
  final List<String> imgList = [
    'assets/images/banner_1.png',
    'assets/images/banner_2.png',
    'assets/images/banner_3.png',
  ];

  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final categoriesData = await _productService.getCategories();
      final productsData = await _productService.getProducts();

      setState(() {
        categories = categoriesData;
        products = productsData;
        filteredProducts = productsData;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        errorMessage = e is ApiException 
            ? e.message 
            : 'Failed to load data. Please try again.';
        isLoading = false;
      });
    }
  }

  void filterProducts() {
    setState(() {
      if (searchQuery.isEmpty) {
        filteredProducts = selectedCategoryIndex == 0 || categories.isEmpty
            ? products
            : products.where((d) => d.category?.name == categories[selectedCategoryIndex - 1].name).toList();
      } else {
        var categoryFiltered = selectedCategoryIndex == 0 || categories.isEmpty
            ? products
            : products.where((d) => d.category?.name == categories[selectedCategoryIndex - 1].name).toList();
        
        filteredProducts = categoryFiltered.where((product) =>
            product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            product.description.toLowerCase().contains(searchQuery.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<TableProvider>(context); // listen: true (mặc định)
    final int? selectedTableNumber = tableProvider.selectedTable?.tableNumber;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    SizedBox(height: 12),
                    if (selectedTableNumber != null)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade800),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.table_bar, color: Colors.amber.shade800),
                            SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black87),
                                  children: [
                                    TextSpan(text: 'Đang đặt món cho '),
                                    TextSpan(
                                      text: 'Bàn số ${selectedTableNumber}',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    BannerCarousel(imgList: imgList),
                    SizedBox(height: 24),
                    Container(
                      child: Text(
                        textAlign: TextAlign.left,
                        "Danh mục sản phẩm",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.brown,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    SizedBox(height: 24),
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
                                filterProducts();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm sản phẩm...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                          filterProducts();
                        },
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: filteredProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.75),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(
                            product: product,
                            onTap: () async {
                              final productDetail = await _productService.getProduct(product.id);
                              if (productDetail != null) {
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetail(
                                        product: productDetail,
                                        tableNumber: selectedTableNumber,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
