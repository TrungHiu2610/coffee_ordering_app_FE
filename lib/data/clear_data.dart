import 'package:flutter_coffee_shop_app/services/realm.dart';
import 'package:realm/realm.dart';
import '../models/models.dart';

void clearData(RealmService realmService) {
  if (realmService.realm.all<Category>().isEmpty) return; // ko dữ liệu thì bỏ qua

  realmService.realm.deleteAll();
}
