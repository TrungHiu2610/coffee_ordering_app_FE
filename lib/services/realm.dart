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
      User.schema
    ]);

    this._realm = Realm(config);
  }

  Realm get realm => _realm;
}