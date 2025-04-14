part of models;

@RealmModel()
class _Cart {
  @PrimaryKey()
  late ObjectId id;

  late DateTime createTime;

  // relationship
  late _User? user;

  @Backlink(#cart)
  late Iterable<_CartItem> cartItems;
}
