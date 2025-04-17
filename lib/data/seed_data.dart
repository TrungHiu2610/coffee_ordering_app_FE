import 'package:flutter_coffee_shop_app/services/realm.dart';
import 'package:realm/realm.dart';
import '../models/models.dart';

void seedInitialData(RealmService realmService) {
  if (realmService.realm.all<Category>().isNotEmpty) return; // đã có dữ liệu thì bỏ qua

  final categories = [
    Category(ObjectId(), "Cà phê"),
    Category(ObjectId(), "Trà sữa"),
    Category(ObjectId(), "Sinh tố"),
    Category(ObjectId(), "Đá xay"),
  ];

  final products = [
    Product(ObjectId(), "Cà phê sữa", 30000, "Cà phê phin sữa truyền thống", "cafe_sua.png", true, category: categories[0]),
    Product(ObjectId(), "Cà phê đen", 28000, "Cà phê phin đen đá", "cafe_den.png", true, category: categories[0]),
    Product(ObjectId(), "Bạc xỉu", 32000, "Bạc xỉu đậm đà vị sữa", "bac_xiu.png", true, category: categories[0]),
    Product(ObjectId(), "Cà phê trứng", 45000, "Cà phê kèm trứng đánh bông", "cafe_trung.png", true, category: categories[0]),
    Product(ObjectId(), "Cà phê dừa", 40000, "Cà phê kèm nước cốt dừa", "cafe_dua.png", true, category: categories[0]),

    Product(ObjectId(), "Trà sữa truyền thống", 35000, "Trà đen, sữa và trân châu", "tra_sua_tt.png", true,category:  categories[1]),
    Product(ObjectId(), "Trà sữa matcha", 38000, "Matcha Nhật và sữa tươi", "tra_sua_matcha.png", true,category:  categories[1]),
    Product(ObjectId(), "Trà sữa thái xanh", 36000, "Trà thái xanh mát lạnh", "tra_sua_thai.png", true,category:  categories[1]),
    Product(ObjectId(), "Trà sữa socola", 37000, "Trà sữa hương cacao", "tra_sua_scl.png", true,category:  categories[1]),
    Product(ObjectId(), "Trà sữa hồng trà", 34000, "Trà đen hương thơm đặc trưng", "tra_sua_hong_tra.png", true,category:  categories[1]),

    Product(ObjectId(), "Sinh tố xoài", 40000, "Xoài chín tươi mát", "sinh_to_xoai.png", true,category:  categories[2]),
    Product(ObjectId(), "Sinh tố bơ", 42000, "Bơ dẻo và béo", "sinh_to_bo.png", true, category: categories[2]),
    Product(ObjectId(), "Sinh tố dâu", 39000, "Dâu tây tươi ngon", "sinh_to_dau.png", true, category: categories[2]),
    Product(ObjectId(), "Sinh tố cam", 38000, "Cam mọng nước mát lạnh", "sinh_to_cam.png", true,category:  categories[2]),
    Product(ObjectId(), "Sinh tố mãng cầu", 43000, "Chua chua ngọt ngọt", "sinh_to_mang_cau.png", true,category:  categories[2]),

    Product(ObjectId(), "Đá xay socola", 45000, "Socola đá xay mát lạnh", "da_xay_scl.png", true, category: categories[3]),
    Product(ObjectId(), "Đá xay cookie", 46000, "Cookie xay cùng sữa", "da_xay_cookie.png", true,category:  categories[3]),
    Product(ObjectId(), "Đá xay matcha", 47000, "Matcha xay cùng đá", "da_xay_matcha.png", true,category:  categories[3]),
    Product(ObjectId(), "Đá xay caramel", 48000, "Caramel đá xay thơm ngọt", "da_xay_caramel.png", true, category: categories[3]),
    Product(ObjectId(), "Đá xay việt quất", 49000, "Việt quất mát lạnh", "da_xay_viet_quat.png", true, category: categories[3]),
  ];

  realmService.realm.write(() {
    categories.forEach(realmService.realm.add);
    products.forEach(realmService.realm.add);
  });
}
