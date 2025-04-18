import 'package:realm/realm.dart';

import '../models/models.dart';

class RealmService
{
  late Realm _realm;

  RealmService()
  {
    final config = Configuration.local([
      Cart.schema,
      CartItem.schema,
      Category.schema,
      Invoice.schema,
      InvoiceItem.schema,
      Product.schema,
      Review.schema,
      User.schema,
      Size.schema,
      Topping.schema,
      ProductSize.schema
    ], schemaVersion: 4);

    this._realm = Realm(config);
  }

  Realm get realm => _realm;

  ObjectId getCurrentUserId() {
    final user = realm.all<User>().first; // hoặc logic login cụ thể của bạn
    return user.id;
  }
}