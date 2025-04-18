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
    ], schemaVersion: 3);

    this._realm = Realm(config);
  }

  Realm get realm => _realm;
}